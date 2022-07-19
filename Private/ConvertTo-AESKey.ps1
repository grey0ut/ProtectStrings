<#
.Synopsis
Function to convert a SecureString object to a unique 32 Byte array for use with AES 256bit encryption
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  03/24/2022
Purpose/Change: Initial function development
Version:        2.0
Author:         C. Bodett
Creation Date:  03/27/2022
Purpose/Change: Abandoned my homebrew method of password based key derivation and leveraged an existing .NET 
Version:        2.1
Author:         C. Bodett
Creation Date:  04/01/2022
Purpose/Change: Changed Salt encoding from UTF8 to Unicode just to be the same as the SecureString method. Apparently SecureString deals exclusively with Unicode. 
Version:        2.2
Author:         C. Bodett
Creation Date:  06/09/2022
Purpose/Change: Changed verbose messages
#>
Function ConvertTo-AESKey {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Security.SecureString]$SecureStringInput,
        #[Parameter(Mandatory = $false)]
        #[String]$Salt = '|½ÁôøwÚ♀å>~I©k◄=ýñíî',
        #[Parameter(Mandatory = $false)]
        #[Int32]$Iterations = 1000,
        [Parameter(Mandatory = $false)]
        [Switch]$ByteArray
    )

    Process {
        Write-Verbose "Retrieving AESKey settings"
        $Settings = Get-AESKeyConfig 
        Write-Verbose "Converting Salt to byte array"
        $SaltBytes = ConvertTo-Bytes -InputString $($Settings.Salt) -Encoding UTF8
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
            # Convert the key bytes to a unicode string -> SecureString
            #$KeyBytesUnicode = ConvertFrom-Bytes -InputBytes $Key -Encoding Unicode
            #$KeyAsSecureString = ConvertTo-SecureString -String $keyBytesUnicode -AsPlainText -Force
            $KeyAsSecureString = ConvertTo-SecureString -String $([System.BitConverter]::ToString($Key)) -AsPlainText -Force
            $KeyOutput = $KeyAsSecureString
        }
        return $KeyOutput
    }
}