BeforeAll {
    Import-Module $ModuleName
}

Describe 'Set-MasterPassword' {
    It 'Should accept SecureString object input' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        try {
            Set-MasterPassword -MasterPassword $Password
            $Failed = $false
        } catch {
            $Failed = $true
        }
        $Failed | Should -BeFalse
    }
}