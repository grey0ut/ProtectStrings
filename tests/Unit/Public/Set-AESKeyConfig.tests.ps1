BeforeAll {
    Import-Module $ModuleName
}

Describe 'Set-AESKeyConfig' {
    It 'Should save AES Key config to disk' {
        # Get Current config in case custom settings exist
        $Current = try {
            Get-AESKeyConfig
        } catch {
            throw "Failed to retrieve current config. Exit build/test"
        }

        try {
            Set-AESKeyConfig -Hash SHA1 -Iterations 1000 -SaltString "testthisthing123456" -ErrorAction Stop
            $Failed = $false
        } catch {
            $Failed = $true
        }
        $Failed | Should -BeFalse
        if (-not($Current.GetType().Name -eq "Hashtable")) {
            #custom settings found from disk
            $SaltBytes = [System.Convert]::FromBase64String($Current.Salt)
            Set-AesKeyConfig -Hash $($Current.Hash) -Iterations $($Current.Iterations) -SaltBytes $SaltBytes
        }
    }
}