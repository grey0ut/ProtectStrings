function ConvertTo-AESCipherText {
    <#
    .SYNOPSIS
    Convert input string to AES encrypted cipher text
    .DESCRIPTION
    Convert input string to AES encrypted cipher text. This is a private function and won't be exposed to the session.
    .PARAMETER InputString
    The string to encrypt with AES256
    .PARAMETER Key
    A byte array containing the 256-bit key used with AES
    .EXAMPLE
    ConvertTo-AESCipherText -InputString "secret" -Key $Key
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0,Mandatory = $true)]
        [string]$InputString,
        [Parameter(Position = 1,Mandatory = $true)]
        [byte[]]$Key
    )

    $InitializationVector = [System.Byte[]]::new(16)
    Get-RandomByte -Bytes $InitializationVector
    $AESCipher = Initialize-AESCipher -Key $Key
    $AESCipher.IV = $InitializationVector
    $ClearTextBytes = ConvertTo-Byte -InputString $InputString -Encoding UTF8
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
    $AESCipher.Dispose()
    $ConvertedString
}