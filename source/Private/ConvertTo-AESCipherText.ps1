<#
.Synopsis
Convert input string to AES encrypted cipher text
#>
Function ConvertTo-AESCipherText {
    [cmdletbinding()]
    param(
        [Parameter(ValueFromPipeline = $true,Position = 0,Mandatory = $true)]
        [string]$InputString,
        [Parameter(Position = 1,Mandatory = $true)]
        [Byte[]]$Key
    )

    Process {
            $InitializationVector = [System.Byte[]]::new(16)
            Get-RandomBytes -Bytes $InitializationVector
            $AESCipher = Initialize-AESCipher -Key $Key
            $AESCipher.IV = $InitializationVector
            $ClearTextBytes = ConvertTo-Bytes -InputString $InputString -Encoding UTF8
            $Encryptor =  $AESCipher.CreateEncryptor()
            $EncryptedBytes = $Encryptor.TransformFinalBlock($ClearTextBytes, 0, $ClearTextBytes.Length)
            [byte[]]$FullData = $AESCipher.IV + $EncryptedBytes
            $ConvertedString = [System.Convert]::ToBase64String($FullData)
            $DebugInfo = @"
`r`n  Input String Length     : $($InputString.Length)
  Initialization Vector   : $($InitializationVector.Count) Bytes
  Text Encoding           : UTF8
  Output Encoding         : Base64
"@
            Write-Debug $DebugInfo
        }

    End {
        $AESCipher.Dispose()
        $ConvertedString
        }

}