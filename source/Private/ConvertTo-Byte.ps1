function ConvertTo-Byte {
    <#
    .SYNOPSIS
    Gets bytes from supplied input string
    .DESCRIPTION
    Gets bytes from supplied input string. This is a private function and won't be exposed to the session
    .PARAMETER InputString
    The string to convert to bytes
    .PARAMETER Encoding
    The text encoding to use with the conversion
    .EXAMPLE
    ConvertTo-Byte -InputString "some text"
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string]$InputString,
        [Parameter(Position=1)]
        [ValidateSet('UTF8','Unicode')]
        [string]$Encoding = 'Unicode'
    )

    Write-Debug "Converting Input text to bytes with $Encoding encoding"
    Write-Debug "Input Text: $InputString"
    $Bytes = [System.Text.Encoding]::$Encoding.GetBytes($InputString)
    $Bytes
}