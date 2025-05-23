BeforeAll {
    Import-Module $ModuleName
}


Describe 'UnProtect-String' {
    It 'Should decrypt with AES' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $CipherText = 'AjjuDn/qi5AC6j/KFRh9TqrKAozSBljBt1nWRjdqtw/E='
        $Result = UnProtect-String -InputString $CipherText
        $Result | Should -Be "test"
    }
    It 'Should handle pipeline input' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $CipherText = 'AjjuDn/qi5AC6j/KFRh9TqrKAozSBljBt1nWRjdqtw/E=', 'AjjuDn/qi5AC6j/KFRh9TqrKAozSBljBt1nWRjdqtw/E='
        $Results = $CipherText | UnProtect-String
        $Results | Should -Not -BeNullOrEmpty
        $Results.Count | Should -Be 2 -Because "Two strings were passed through the pipeline"
    }
}