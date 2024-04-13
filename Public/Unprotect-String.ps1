Function UnProtect-String {
    <#
    .Synopsis
    Decrypt a provided string using either DPAPI or AES encryption
    .Description
    This function will decode the provided protected text, and automatically determine if it was encrypted using DPAPI or AES encryption. 
    If no master password has been set it will prompt for one. 
    If there is a decryption problem it will notify. 
    .Parameter InputString
    This is the protected text previously produced by the ProtectStrings module. Encryption type will be automatically determined.
    .EXAMPLE
    PS C:\> Protect-String "Secret message"
    eyJFbmNyeXB0aW9uIjoiRFBBUEkiLCJDaXBoZXJUZXh0IjoiMDEwMDAwMDBkMDhjOWRkZjAxMTVkMTExOGM3YTAwYzA0ZmMyOTdlYjAxMDAwMDAwODRkMTVhY2QwZjk5ZDM0NDllNzE5MTkwZGI0YzY2ZWUwMDAwMDAwMDAyMDAwMDAwMDAwMDAzNjYwMDAwYzAwMDAwMDAxMDAwMDAwMGMyNjFhZTY5YThjZjdlMTI0ZTJmZWI3MmVmMTk3YmRlMDAwMDAwMDAwNDgwMDAwMGEwMDAwMDAwMTAwMDAwMDA4NjUxZWJjZWY4MTE4MzEzMzljNDMyNjA5OWUxZWY3ZDIwMDAwMDAwZGQ3MDUyNGFkZGZlMmM5YzQyMDlhZDc2NjYzZTlhMzgxMTBjNDJkMjk3ZDNhOGQ2OGY4MGI1NDU0YTIxNTUyZjE0MDAwMDAwZThmYjFmY2YyMzYyM2U4NjRmMDliMzA1ZmI4ZTM1ZWRkMjBmNzU2NCIsIkRQQVBJSWRlbnRpdHkiOiJMTklQQzIwMzQ3NExcXEJvZGV0dEMifQ==

    This command will encrypt the provided string with DPAPI encryption and return the encoded cipher text.

    PS C:\> Unprotect-String 'eyJFbmNyeXB0aW9uIjoiRFBBUEkiLCJDaXBoZXJUZXh0IjoiMDEwMDAwMDBkMDhjOWRkZjAxMTVkMTExOGM3YTAwYzA0ZmMyOTdlYjAxMDAwMDAwODRkMTVhY2QwZjk5ZDM0NDllNzE5MTkwZGI0YzY2ZWUwMDAwMDAwMDAyMDAwMDAwMDAwMDAzNjYwMDAwYzAwMDAwMDAxMDAwMDAwMGMyNjFhZTY5YThjZjdlMTI0ZTJmZWI3MmVmMTk3YmRlMDAwMDAwMDAwNDgwMDAwMGEwMDAwMDAwMTAwMDAwMDA4NjUxZWJjZWY4MTE4MzEzMzljNDMyNjA5OWUxZWY3ZDIwMDAwMDAwZGQ3MDUyNGFkZGZlMmM5YzQyMDlhZDc2NjYzZTlhMzgxMTBjNDJkMjk3ZDNhOGQ2OGY4MGI1NDU0YTIxNTUyZjE0MDAwMDAwZThmYjFmY2YyMzYyM2U4NjRmMDliMzA1ZmI4ZTM1ZWRkMjBmNzU2NCIsIkRQQVBJSWRlbnRpdHkiOiJMTklQQzIwMzQ3NExcXEJvZGV0dEMifQ=='
    Secret message

    Feeding the previously output protected text to Unprotect-String will decrypt it and return the original string text.
    .EXAMPLE
    PS C:\> Protect-String "Secret message" -Encryption AES
    Enter Master Password: ********
    eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IktUU2RYVG9tREt0M1N5eFN0OGsveGtxc2xjTjhseUZMQTllMDlWQWdkVTA9IiwiRFBBUElJZGVudGl0eSI6IiJ9

    This command will encrypt the provided string with AES 256-bit encryption. If no Master Password is found in the current session (set with Set-MasterPassword) then it will prompt for one  to be set.

    PS C:\> Clear-MasterPassword
    PS C:\> Unprotect-String 'eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IktUU2RYVG9tREt0M1N5eFN0OGsveGtxc2xjTjhseUZMQTllMDlWQWdkVTA9IiwiRFBBUElJZGVudGl0eSI6IiJ9'
    Enter Master Password: ********
    Secret message

    Clearing the master password from the sessino, providing the previously protected text to Unprotect-String will prompt for a master password and then decrypt the text and return the original string text.
    .NOTES
    Version:        1.3
    Author:         C. Bodett
    Creation Date:  4/12/2024
    Purpose/Change: formatting changes
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [String]$InputString
    )
    
    Process {
        Write-Verbose "Converting supplied text to a Cipher Object for ProtectStrings"
        $CipherObject = Try {
            ConvertTo-CipherObject $InputString -ErrorAction Stop
        } Catch {
            Write-Warning "Supplied text could not be converted to a Cipher Object. Verify that it was produced by Protect-String."
            return
        }
        Write-Verbose "Encryption type: $($CipherObject.Encryption)"
        If ($CipherObject.Encryption -eq "AES") {
            $SecureAESKey = Get-AESMPVariable
            $ClearTextAESKey = ConvertFrom-SecureStringToPlainText $SecureAESKey
            $AESKey = Convert-HexStringToByteArray -HexString $ClearTextAESKey
        }
        Switch ($CipherObject.Encryption) {
            "DPAPI" {
                Try {
                    Write-Verbose "Attempting to create a SecureString object from DPAPI cipher text"
                    $SecureStringObj = ConvertTo-SecureString -String $CipherObject.CipherText -ErrorAction Stop
                    $ConvertedString = ConvertFrom-SecureStringToPlainText -StringObj $SecureStringObj -ErrorAction Stop
                    $CorrectPassword = $true
                    $ConvertedString
                } Catch {
                    Write-Warning "Unable to decrypt as this user on this machine"
                    Write-Verbose "String protected by Identity: $($CipherObject.DPAPIIdentity)"
                    $CorrectPassword = $false
                }
            }
            "AES" {
                Try {
                    Write-Verbose "Attempting to decrypt AES cipher text"
                    $ConvertedString = ConvertFrom-AESCipherText -InputCipherText $CipherObject.CipherText -Key $AESKey -ErrorAction Stop
                    $CorrectPassword = $true
                    $ConvertedString
                } Catch {
                    Write-Warning "Failed to decrypt. Incorrect AES key. Check your Master Password."
                    $CorrectPassword = $false
                    Clear-AESMPVariable
                }
            }
        }

    }
}