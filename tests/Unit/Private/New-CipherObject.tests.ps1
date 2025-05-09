BeforeAll {
    Import-Module $ModuleName
}

Describe 'New-CipherObject' {
    It 'Should return an object of type CipherObject' {
        InModuleScope $ModuleName {
            $Base64 = 'AGeH9DzCXTLpUufe9vmuyEhl1/R02FXZxG43F6cDuW8Q='
            $Result = ConvertTo-CipherObject -B64String $Base64
            $Result.GetType().Name | Should -Be "CipherObject"
        }
    }
}