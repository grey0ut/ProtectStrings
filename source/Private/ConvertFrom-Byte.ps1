function ConvertFrom-Byte {
    <#
    .SYNOPSIS
    Gets string from supplied input bytes
    .DESCRIPTION
    Gets string from supplied input bytes. This is a private function and won't be exposed in the session.
    .PARAMETER InputBytes
    The byte array to convert to text
    .PARAMETER Encoding
    The text encoding to use with the conversion
    .EXAMPLE
    ConvertFrom-Byte -InputBytes $Bytes
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [Byte[]]$InputBytes,
        [Parameter(Position=1)]
        [ValidateSet('UTF8','Unicode')]
        [string]$Encoding = 'Unicode'
    )

    Write-Verbose "Converting from bytes to string using $Encoding encoding"
    $OutputString = [System.Text.Encoding]::$Encoding.GetString($InputBytes)
    $OutputString
}