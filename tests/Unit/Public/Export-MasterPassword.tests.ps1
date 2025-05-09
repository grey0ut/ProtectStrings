BeforeAll {
    Import-Module $ModuleName
}

Describe 'Export-MasterPassword' {
    It 'Should produce no console output' {
        Clear-MasterPassword
        $Destination = if ($ENV:HOME) {
            $ENV:HOME
        } else {
            $ENV:TEMP
        }
        $Result = Export-MasterPassword -FilePath $Destination
        $Result | Should -BeNullOrEmpty
    }
}