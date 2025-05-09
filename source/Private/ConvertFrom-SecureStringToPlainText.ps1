function ConvertFrom-SecureStringToPlainText {
    <#
    .SYNOPSIS
    Decrypts a secure string from the memory object in to plain text
    .DESCRIPTION
    Decrypts a secure string from the memory object in to plain text. This is a private function and won't be exposed to the session.
    .PARAMETER StringObj
    The secure string object reference
    .EXAMPLE
    ConvertFrom-SecureStringToPlainText -StringObj $SecureString
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param(
        [System.Security.SecureString]$StringObj
    )

    $BSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($StringObj)
    $PlainText = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    $PlainText
}