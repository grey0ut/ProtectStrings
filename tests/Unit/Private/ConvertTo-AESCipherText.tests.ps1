BeforeAll {
    Import-Module $ModuleName
}

Describe 'ConvertTo-AESCipherText' {
    It 'Should create encrypted text' {
        InModuleScope $ModuleName {
            $Key = 'Vns5EjznZDPbTYEHTD+okRmQYbJAkjFntGT6rqsbrvY='
            $KeyBytes = [System.Convert]::FromBase64String($Key)
            try {
                $Result = ConvertTo-AESCipherText -InputString "test" -Key $KeyBytes
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Result -ne $null | Should -BeTrue
            $Failed | Should -BeFalse
        }
    }
}