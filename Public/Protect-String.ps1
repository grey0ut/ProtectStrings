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
    eyJFbmNyeXB0aW9uIjoiRFBBUEkiLCJDaXBoZXJUZXh0IjoiMDEwMDAwMDBkMDhjOWRkZjAxMTVkMTExOGM3YTAwYzA0ZmMyOTdlYjAxMDAwMDAwODRkMTVhY2QwZjk5ZDM0NDllNzE5MTkwZGI0YzY2ZWUwMDAwMDAwMDAyMDAwMDAwMDAwMDAzNjYwMDAwYzAwMDAwMDAxMDAwMDAwMGMyNjFhZTY5YThjZjdlMTI0ZTJmZWI3MmVmMTk3YmRlMDAwMDAwMDAwNDgwMDAwMGEwMDAwMDAwMTAwMDAwMDA4NjUxZWJjZWY4MTE4MzEzMzljNDMyNjA5OWUxZWY3ZDIwMDAwMDAwZGQ3MDUyNGFkZGZlMmM5YzQyMDlhZDc2NjYzZTlhMzgxMTBjNDJkMjk3ZDNhOGQ2OGY4MGI1NDU0YTIxNTUyZjE0MDAwMDAwZThmYjFmY2YyMzYyM2U4NjRmMDliMzA1ZmI4ZTM1ZWRkMjBmNzU2NCIsIkRQQVBJSWRlbnRpdHkiOiJMTklQQzIwMzQ3NExcXEJvZGV0dEMifQ==

    This command will encrypt the provided string with DPAPI encryption and return the encoded cipher text.
    .EXAMPLE
    PS C:\> Protect-String "Secret message" -Encryption AES
    Enter Master Password: ********
    eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IktUU2RYVG9tREt0M1N5eFN0OGsveGtxc2xjTjhseUZMQTllMDlWQWdkVTA9IiwiRFBBUElJZGVudGl0eSI6IiJ9

    This command will encrypt the provided string with AES 256-bit encryption. If no Master Password is found in the current session (set with Set-MasterPassword) then it will prompt for one  to be set.
    .NOTES
    Version:        1.2
    Author:         C. Bodett
    Creation Date:  4/12/2024
    Purpose/Change: Updated for cross platform use
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
                    $JSONObject = ConvertTo-Json -InputObject $CipherObject -Compress
                    $JSONBytes = ConvertTo-Bytes -InputString $JSONObject -Encoding UTF8
                    $EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
                    $EncodedOutput
                } Catch {
                    Write-Error $Error[0]
                }
            }
            "AES" {
                Try {
                    Write-Verbose "Encrypting string text with AES 256-bit"
                    $ConvertedString = ConvertTo-AESCipherText -InputString $InputString -Key $AESKey -ErrorAction Stop
                    $CipherObject = New-CipherObject -Encryption "AES" -CipherText $ConvertedString
                    $JSONObject = ConvertTo-Json -InputObject $CipherObject -Compress
                    $JSONBytes = ConvertTo-Bytes -InputString $JSONObject -Encoding UTF8
                    $EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
                    $EncodedOutput
                } Catch {
                    Write-Error $Error[0]
                }
            }
        }
    }
}