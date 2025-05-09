BeforeAll {
    Import-Module $ModuleName
}


Describe 'ConvertTo-CipherObject' {
    It 'Should return an object of type CipherObject' {
        InModuleScope $ModuleName {
            $Base64 = 'AGeH9DzCXTLpUufe9vmuyEhl1/R02FXZxG43F6cDuW8Q='
            $Result = ConvertTo-CipherObject -B64String $Base64
            $Result.GetType().Name | Should -Be "CipherObject"
        }
    }
    It 'Should reject Base64 input that was not created by this module' {
        InModuleScope $ModuleName {
            $Base64 = 'GeH9DzCXTLpUufe9vmuyEhl1/R02FXZxG43F6cDuW8Q='
            try {
                $Result = ConvertTo-CipherObject -B64String $Base64
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Failed | Should -BeTrue
        }
    }
    It 'Should identify AES encryption' {
        InModuleScope $ModuleName {
            $Base64 = 'AGeH9DzCXTLpUufe9vmuyEhl1/R02FXZxG43F6cDuW8Q='
            $Result = ConvertTo-CipherObject -B64String $Base64
            $Result.GetType().Name | Should -Be "CipherObject"
            $Result.Encryption | Should -Be "AES"
        }
    }
    It 'Should identify DPAPI encryption' {
        InModuleScope $ModuleName {
            $Base64 = 'DAQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAbkcdFfoRPkyh7LAp2HBlSgAAAAACAAAAAAADZgAAwAAAABAAAAAUDv5TZjtoT/V26CRiJUseAAAAAASAAACgAAAAEAAAAGrSEsHxuop3Zv4tRy5k89oIAAAAXiecdMurOTIUAAAA9IcmXykFkhf9/cOQotj2i5411fQ=?'
            $Result = ConvertTo-CipherObject -B64String $Base64
            $Result.GetType().Name | Should -Be "CipherObject"
            $Result.Encryption | Should -Be "DPAPI"
        }
    }
}