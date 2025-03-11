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
    D01000000d08c9ddf0115d1118c7a00c04fc297eb010000001a8fc10bbb86cc449a5103047b4b246d0000000002000000000003660000c0000000100000003960a9bffe1fcf050567397531eb71da0000000004800000a00000001000000098435688c310d7254279e472ce2bf2b820000000eaca228aae688c9f8dc1eb304178078cbe0d54364b922d453b8899ca3b438c5a14000000848a67d2fb9c54bd64833d89387c0f4193422ff5?TE5JUEMyMjIxNTBMXEJvZGV0dEM=

    This command will encrypt the provided string with DPAPI encryption and return the encoded cipher text.

    PS C:\> Unprotect-String 'D01000000d08c9ddf0115d1118c7a00c04fc297eb010000001a8fc10bbb86cc449a5103047b4b246d0000000002000000000003660000c0000000100000003960a9bffe1fcf050567397531eb71da0000000004800000a00000001000000098435688c310d7254279e472ce2bf2b820000000eaca228aae688c9f8dc1eb304178078cbe0d54364b922d453b8899ca3b438c5a14000000848a67d2fb9c54bd64833d89387c0f4193422ff5?TE5JUEMyMjIxNTBMXEJvZGV0dEM='
    Secret message

    Feeding the previously output protected text to Unprotect-String will decrypt it and return the original string text.
    .EXAMPLE
    PS C:\> Protect-String "Secret message" -Encryption AES
    Enter Master Password: ********
    A7B3uXRDkDZkejQVQhwqn2I4KJjsxfqCbc1a+9Jgg620=

    This command will encrypt the provided string with AES 256-bit encryption. If no Master Password is found in the current session (set with Set-MasterPassword) then it will prompt for one  to be set.

    PS C:\> Clear-MasterPassword
    PS C:\> Unprotect-String 'A7B3uXRDkDZkejQVQhwqn2I4KJjsxfqCbc1a+9Jgg620='
    Enter Master Password: ********
    Secret message

    Clearing the master password from the sessino, providing the previously protected text to Unprotect-String will prompt for a master password and then decrypt the text and return the original string text.
    .NOTES
    Version:        1.4.
    Author:         C. Bodett
    Creation Date:  12/5/2024
    Purpose/Change: updated to handle the new output type from Protect-String
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
                    $ConvertedString
                } Catch {
                    Write-Warning "Unable to decrypt as this user on this machine"
                    Write-Verbose "String protected by Identity: $($CipherObject.DPAPIIdentity)"
                }
            }
            "AES" {
                Try {
                    Write-Verbose "Attempting to decrypt AES cipher text"
                    $ConvertedString = ConvertFrom-AESCipherText -InputCipherText $CipherObject.CipherText -Key $AESKey -ErrorAction Stop
                    $ConvertedString
                } Catch {
                    Write-Warning "Failed to decrypt. Incorrect AES key. Check your Master Password."
                    Clear-AESMPVariable
                }
            }
        }
    }
}