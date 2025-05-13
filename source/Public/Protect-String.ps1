function Protect-String {
    <#
    .SYNOPSIS
    Encrypt a provided string with DPAPI or AES 256-bit encryption and return the cipher text.
    .DESCRIPTION
    This function will encrypt provided string text with either Microsoft's DPAPI or AES 256-bit encryption. By default it will use DPAPI unless specified.
    Returns a string object of Base64 encoded text.
    .PARAMETER InputString
    This is the string text you wish to protect with encryption. Can  be provided via the pipeline.
    .PARAMETER Encryption
    Specify either DPAPI or AES encryption. AES is the default if not specified. DPAPI is not recommended on non-Windows systems are there is no encryption for SecureStrings.
    .EXAMPLE
    PS C:\> Protect-String "Secret message"
    D01000000d08c9ddf0115d1118c7a00c04fc297eb010000001a8fc10bbb86cc449a5103047b4b246d0000000002000000000003660000c0000000100000003960a9bffe1fcf050567397531eb71da0000000004800000a00000001000000098435688c310d7254279e472ce2bf2b820000000eaca228aae688c9f8dc1eb304178078cbe0d54364b922d453b8899ca3b438c5a14000000848a67d2fb9c54bd64833d89387c0f4193422ff5?TE5JUEMyMjIxNTBMXEJvZGV0dEM=

    This command will encrypt the provided string with DPAPI encryption and return the encoded cipher text.
    .EXAMPLE
    PS C:\> Protect-String "Secret message" -Encryption AES
    Enter Master Password: ********
    A7B3uXRDkDZkejQVQhwqn2I4KJjsxfqCbc1a+9Jgg620=

    This command will encrypt the provided string with AES 256-bit encryption. If no Master Password is found in the current session (set with Set-MasterPassword) then it will prompt for one  to be set.
    #>
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars','',Justification='Required for QoL')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$InputString,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("DPAPI","AES")]
        [string]$Encryption = "AES"
    )

    begin {
        Write-Verbose "Encryption Type: $Encryption"
        if ($Encryption -eq "AES") {
            Write-Verbose "Retrieving Master Password key"
            if (Get-MasterPassword -Boolean) {
                $SecureAESKey = Get-MasterPassword
            } else {
                Write-Verbose "No Master Password key found"
                Set-MasterPassword
                $SecureAESKey = Get-MasterPassword
            }
            $SecureAESKey = $Global:AESMP
            $ClearTextAESKey = ConvertFrom-SecureStringToPlainText $SecureAESKey
            $AESKey = Convert-HexStringToByteArray -HexString $ClearTextAESKey
        }
        if (Test-Path Variable:IsWindows) {
            # we know we're not running on Windows since $IsWindows was introduced in v6
            if (-not($IsWindows) -and ($Encryption.ToUpper() -eq "DPAPI")) {
                throw "Cannot use DPAPI encryption on non-Windows host. Please use AES instead."
            }
        }
        Add-Type -AssemblyName System.Security
    }

    process {
        switch ($Encryption) {
            "DPAPI" {
                try {
                    Write-Verbose "Converting string text to a SecureString object"
                    $StringBytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
                    $DPAPIBytes = [System.Security.Cryptography.ProtectedData]::Protect($StringBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
                    $ConvertedString = [System.Convert]::ToBase64String($DPAPIBytes)
                    $CipherObject = New-CipherObject -Encryption "DPAPI" -CipherText $ConvertedString
                    $CipherObject.DPAPIIdentity = '{0}\{1}' -f $ENV:COMPUTERNAME,[System.Environment]::UserName
                    Write-Verbose "DPAPI Identity: $($CipherObject.DPAPIIdentity)"
                    $CipherObject.ToCompressed()
                } catch {
                    Write-Error $_
                }
            }
            "AES" {
                try {
                    Write-Verbose "Encrypting string text with AES 256-bit"
                    $ConvertedString = ConvertTo-AESCipherText -InputString $InputString -Key $AESKey -ErrorAction Stop
                    $CipherObject = New-CipherObject -Encryption "AES" -CipherText $ConvertedString
                    $CipherObject.ToCompressed()
                } catch {
                    Write-Error $_
                }
            }
        }
    }
}