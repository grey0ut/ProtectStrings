BeforeAll {
    Import-Module $ModuleName
}

Describe 'Get-MasterPassword' {
    It 'Should return nothing if no password set' {
        Clear-MasterPassword
        $Result = Get-MasterPassword
        $Result | Should -BeNullOrEmpty
    }
    It 'Should return a boolean with password set and -Boolean switch provided' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $Result = Get-MasterPassword -Boolean
        $Result | Should -BeTrue
    }
    It 'Should return a SecureString object if a password has been set' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $Result = Get-MasterPassword
        $Result.GetType().Name | Should -Be "SecureString"
    }
}