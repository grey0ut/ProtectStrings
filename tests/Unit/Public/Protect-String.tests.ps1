BeforeAll {
    Import-Module $ModuleName
}

Describe 'Protect-String' {
    It 'Should encrypt with AES' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $Result = Protect-String -InputString "test" -Encryption AES
        $Result | Should -Not -BeNullOrEmpty
    }
    It 'Should encrypt with DPAPI on Windows' {
        if (Test-Path Variable:IsWindows) {
            # we know we're not running on Windows since $IsWindows was introduced in v6
            $IsWindows | Should -BeNullOrEmpty -Because 'The IsWindows variable was not introduced until PS v6'
        } else {
            $Result = Protect-String -InputString "test" -Encryption DPAPI
            $Result | Should -Not -BeNullOrEmpty
        }
    }
    It 'Should NOT encrypt with DPAPI on non-Windows' {
        if (Test-Path Variable:IsWindows) {
            # we know we're not running on Windows since $IsWindows was introduced in v6
            if ($IsWindows) {
                $IsWindows | Should -BeFalse -Because 'The IsWindows Variable should either not exist or be False on a non-Windows host'
            } else {
                $Result = try {
                    Protect-String -InputString "test" -Encryption DPAPI -ErrorAction Stop
                } catch {
                    $ErrorText = $_.ErrorRecord
                }
                $Result | Should -BeNullOrEmpty
                $ErrorText | Should -Be "Cannot use DPAPI encryption on non-Windows host. Please use AES instead."
            }
        } else {
            $IsWindows | Should -BeFalse -Because 'The IsWindows Variable should either not exist or be False on a non-Windows host'
        }
    }
    It 'Should handle pipeline input' {
        $Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
        Set-MasterPassword -MasterPassword $Password
        $Result = "test" | Protect-String -Encryption AES
        $Result | Should -Not -BeNullOrEmpty
        $Results = "test1","test2" | Protect-String -Encryption AES
        $Results.Count | Should -Be 2 -Because "Two strings were passed through the pipeline"
    }
}