<#
.Synopsis
Function to convert a SecureString object to a unique 32 Byte array for use with AES 256bit encryption
.NOTES
Version:        3.0
Author:         C. Bodett
Creation Date:  11/03/2022
Purpose/Change: Changed salt storage method to Base64 encoding for more reliable operation.
#>
Function ConvertTo-AESKey {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Security.SecureString]$SecureStringInput,
        [Parameter(Mandatory = $false)]
        [Switch]$ByteArray
    )

    Process {
        try {
            Write-Verbose "Retrieving AESKey settings"
            $Settings = Get-AESKeyConfig -ErrorAction Stop
        } catch {
            throw "Failed to get AES Key config settings"
        }
        Write-Verbose "Converting Salt to byte array"
        $SaltBytes = ConvertFrom-Base64 -Textstring $($Settings.Salt) -OutputType Bytes
        # Temporarily plaintext our SecureString password input. There's really no way around this.
        Write-Verbose "Converting supplied SecureString text to plaintext"
        $Password = ConvertFrom-SecureStringToPlainText $SecureStringInput
        # Create our PBKDF2 object and instantiate it with the necessary values
        $VMsg = @"
`r`n        Creating PBKDF2 Object
        Password....: $("*"*$($Password.Length))
        Salt........: $($Settings.Salt)
        Iterations..: $($Settings.Iterations)
        Hash........: $($Settings.Hash)
"@
        Write-Verbose $VMsg
        $PBKDF2 = New-Object Security.Cryptography.Rfc2898DeriveBytes  -ArgumentList @($Password, $SaltBytes, $($Settings.Iterations), $($Settings.Hash))
        # Generate our AES Key
        Write-Verbose "Generating 32 byte key"
        $Key = $PBKDF2.GetBytes(32)
        # If the ByteArray switch is provided, return a plaintext byte array, otherwise turn our AES key in to a SecureString object
        If ($ByteArray) {
            Write-Verbose "ByteArray switch provided. Returning clear text array of bytes"
            $KeyOutput = $Key
        } Else {
            $KeyAsSecureString = ConvertTo-SecureString -String $([System.BitConverter]::ToString($Key)) -AsPlainText -Force
            $KeyOutput = $KeyAsSecureString
        }
        $KeyOutput
    }
}