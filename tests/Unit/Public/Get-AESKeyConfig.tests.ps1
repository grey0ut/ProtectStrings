BeforeAll {
    Import-Module $ModuleName
}

Describe 'Get-AESKeyConfig' {
    It 'Should return output' {
        $Result = Get-AESKeyConfig
        $Result | Should -Not -BeNullOrEmpty
    }
}