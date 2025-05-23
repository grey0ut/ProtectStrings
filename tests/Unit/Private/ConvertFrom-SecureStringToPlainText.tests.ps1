BeforeAll {
    Import-Module $ModuleName
}

Describe 'ConvertFrom-SecureStringToPlainText' {
    It 'Should reveal plain text when given a Secure.String obj' {
        InModuleScope $ModuleName {
            $SecureString = "test" | ConvertTo-SecureString -AsPlainText -Force
            ConvertFrom-SecureStringToPlainText -StringObj $SecureString | Should -be "test"
        }
    }
}