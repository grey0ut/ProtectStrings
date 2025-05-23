BeforeAll {
    Import-Module $ModuleName
}


Describe 'ConvertFrom-AESCipherText' {
    It 'Should decrypt AES cipher text' {
        InModuleScope $ModuleName {
            $Key = 'Vns5EjznZDPbTYEHTD+okRmQYbJAkjFntGT6rqsbrvY='
            $KeyBytes = [System.Convert]::FromBase64String($Key)
            $CipherText = 'GeH9DzCXTLpUufe9vmuyEhl1/R02FXZxG43F6cDuW8Q='
            try {
                $Result = ConvertFrom-AESCipherText -InputCipherText $CipherText -Key $KeyBytes
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Result | Should -Be "test"
            $Failed | Should -BeFalse
        }
    }
}