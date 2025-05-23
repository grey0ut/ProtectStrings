BeforeAll {
    Import-Module $ModuleName
}

Describe 'ConvertTo-AESKey' {
    It 'Should return a SecureString object' {
        InModuleScope $ModuleName {
            $Password = "ThisIsATestPassword" | ConvertTo-SecureString -AsPlainText -Force
            try {
                $Result = ConvertTo-AESKey -SecureStringInput $Password
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Result.GetType().Name -eq "SecureString" | Should -BeTrue
            $Failed | Should -BeFalse
        }
    }
    It 'Should return a byte array' {
        InModuleScope $ModuleName {
            $Password = "ThisIsATestPassword" | ConvertTo-SecureString -AsPlainText -Force
            try {
                $Result = ConvertTo-AESKey -SecureStringInput $Password -ByteArray
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Result.GetType().BaseType.Name -eq "Array" | Should -BeTrue
            $Result[0].GetType().Name | Should -Be "Byte"
            $Failed | Should -BeFalse
        }
    }
}