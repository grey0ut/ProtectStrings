Function Protect-String {
    <#
    .Synopsis
    Encrypt a provided string with DPAPI or AES 256-bit encryption and return the cipher text.
    .Description
    This function will encrypt provided string text with either Microsoft's DPAPI or AES 256-bit encryption. By default it will use DPAPI unless specified.
    Returns a string object of Base64 encoded text.
    .Parameter InputString
    This is the string text you wish to protect with encryption. Can  be provided via the pipeline.
    .Parameter Encryption
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
    .NOTES
    Version:        1.3
    Author:         C. Bodett
    Creation Date:  12/5/2024
    Purpose/Change: Changed how output is handled to reduce length
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [String]$InputString,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("DPAPI","AES")]
        [String]$Encryption = "AES"
    )
    
    Begin {
        Write-Verbose "Encryption Type: $Encryption"
        If ($Encryption -eq "AES") {
            Write-Verbose "Retrieving Master Password key"
            $SecureAESKey = Get-AESMPVariable
            $ClearTextAESKey = ConvertFrom-SecureStringToPlainText $SecureAESKey
            $AESKey = Convert-HexStringToByteArray -HexString $ClearTextAESKey
        }
        If (Test-Path Variable:IsWindows) {
            # we know we're not running on Windows since $IsWindows was introduced in v6
            If (-not($IsWindows) -and ($Encryption.ToUpper() -eq "DPAPI")) {
                throw "Cannot use DPAPI encryption on non-Windows host. Please use AES instead."
            }
        }
    }

    Process {
        Switch ($Encryption) {
            "DPAPI" {
                Try {
                    Write-Verbose "Converting string text to a SecureString object"
                    $ConvertedString = ConvertTo-SecureString $InputString -AsPlainText -Force | ConvertFrom-SecureString
                    $CipherObject = New-CipherObject -Encryption "DPAPI" -CipherText $ConvertedString
                    $CipherObject.DPAPIIdentity = Get-DPAPIIdentity
                    Write-Verbose "DPAPI Identity: $($CipherObject.DPAPIIdentity)"
                    #$JSONObject = ConvertTo-Json -InputObject $CipherObject -Compress
                    #$JSONBytes = ConvertTo-Bytes -InputString $JSONObject -Encoding UTF8
                    #$EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
                    #$EncodedOutput
                    $CipherObject.ToCompressed()
                } Catch {
                    Write-Error $_
                }
            }
            "AES" {
                Try {
                    Write-Verbose "Encrypting string text with AES 256-bit"
                    $ConvertedString = ConvertTo-AESCipherText -InputString $InputString -Key $AESKey -ErrorAction Stop
                    $CipherObject = New-CipherObject -Encryption "AES" -CipherText $ConvertedString
                    #$JSONObject = ConvertTo-Json -InputObject $CipherObject -Compress
                    #$JSONBytes = ConvertTo-Bytes -InputString $JSONObject -Encoding UTF8
                    #$EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
                    #$EncodedOutput
                    $CipherObject.ToCompressed()
                } Catch {
                    Write-Error $_
                }
            }
        }
    }
}