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
    Specify either DPAPI or AES encryption. DPAPI is the default if not specified.
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
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  3/28/2022
    Purpose/Change: Initial function development
    Version:        1.1
    Author:         C. Bodett
    Creation Date:  5/12/2022
    Purpose/Change: changed to Generic List from ArrayList
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [String]$InputString,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("DPAPI","AES")]
        [String]$Encryption = "DPAPI"
    )
    
    Begin {
        Write-Verbose "Encryption Type: $Encryption"
        If ($Encryption -eq "AES") {
            Write-Verbose "Retrieving Master Password key"
            $SecureAESKey = Get-AESMPVariable
            $ClearTextAESKey = ConvertFrom-SecureStringToPlainText $SecureAESKey
            #$AESKey = ConvertTo-Bytes -InputString $ClearTextAESKey -Encoding Unicode
            $AESKey = Convert-HexStringToByteArray -HexString $ClearTextAESKey
        }
        $OutputString = [System.Collections.Generic.List[String]]::New()
    }

    Process {
        Switch ($Encryption) {
            "DPAPI" {
                Try {
                    Write-Verbose "Converting string text to a SecureString object"
                    $ConvertedString = ConvertTo-SecureString $InputString -AsPlainText -Force | ConvertFrom-SecureString
                    $CipherObject = New-CipherObject -Encryption "DPAPI" -CipherText $ConvertedString
                    $CipherObject.DPAPIIdentity = Get-DPAPIIdentity
                    Write-Debug "DPAPI Identity: $($CipherObject.DPAPIIdentity)"
                    $JSONObject = ConvertTo-Json -InputObject $CipherObject -Compress
                    $JSONBytes = ConvertTo-Bytes -InputString $JSONObject -Encoding UTF8
                    $EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
                    $OutputString.add($EncodedOutput)
                } Catch {
                    Write-Error $_
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
                    $OutputString.add($EncodedOutput)
                } Catch {
                    Write-Error $_
                }
            }
        }
    }

    End {
        Write-Verbose "Protection complete. Returning $($OutputString.count) objects"
        Return $OutputString
    }
}