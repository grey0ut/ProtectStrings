function ConvertFrom-AESCipherText {
    <#
    .SYNOPSIS
    Convert input AES Cipher text to plain text
    .DESCRIPTION
    Converts input AES cipher text to plain text.  This is a private function that won't be exposed in the session.
    .PARAMETER InputCipherText
    The cipher text to convert
    .PARAMETER Key
    A byte array containing the 256-bit AES key
    .EXAMPLE
    ConvertFrom-AESCipherText -InputCipherText $CipherText -Key $AESKey
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param(
        [Parameter(ValueFromPipeline = $true,Position = 0,Mandatory = $true)]
        [string]$InputCipherText,
        [Parameter(Position = 1,Mandatory = $true)]
        [byte[]]$Key
    )

    process {
        Write-Verbose "Creating new AES Cipher object with supplied key"
        $AESProvider = [System.Security.Cryptography.AesCryptoServiceProvider]::Create()
        $AESProvider.Key = $Key
        Write-Verbose "Convert input text from Base64"
        $EncryptedBytes = [System.Convert]::FromBase64String($InputCipherText)
        Write-Verbose "Using the first 16 bytes as the initialization vector"
        $AESProvider.IV = $EncryptedBytes[0..15]
        Write-Verbose "Decrypting AES cipher text"
        $Decryptor = $AESProvider.CreateDecryptor()
        $UnencryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 16, $EncryptedBytes.Length - 16)
        $ConvertedString = [System.Text.Encoding]::UTF8.GetString($UnencryptedBytes)
        $ConvertedString
    }

    end {
        Write-Verbose "Disposing of AES Cipher object"
        $AESProvider.Dispose()
    }
}