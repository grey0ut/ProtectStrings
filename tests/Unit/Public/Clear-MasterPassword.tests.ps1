BeforeAll {
    Import-Module $ModuleName
}

Describe 'Clear-MasterPassword' {
    It 'Should produce no output' {
        $Result = Clear-MasterPassword
        $Result | Should -BeNullOrEmpty
    }
}