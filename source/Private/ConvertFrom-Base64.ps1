function ConvertFrom-Base64 {
    <#
    .SYNOPSIS
    Converts a Base64 string in to plaintext.
    .DESCRIPTION
    Takes a Base64 string as a parameter, either directly or from the pipeline, and converts it in to plaintext.
    .PARAMETER TextString
    The Base64 string. Can come from the pipeline.
    .PARAMETER Encoding
    Default encoding is UTF8, but this can be Unicode or UTF8 if you're having problems.
    .PARAMETER OutputType
    Select whether to return the decoded value as a string or a byte array
    .EXAMPLE
    ConvertFrom-base64 -TextString $Base64 -Encoding UTF8
    #>
    [cmdletbinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$TextString,
        [Parameter(Position = 1)]
        [ValidateSet('UTF8','Unicode')]
        [string]$Encoding = 'UTF8',
        [Parameter(Position = 2)]
        [ValidateSet('Bytes','String')]
        [string]$OutputType = 'String'
    )

    if ($OutputType -eq 'String') {
        $Decoded = [System.Text.Encoding]::$encoding.GetString([System.Convert]::FromBase64String($TextString))
    } else {
        $Decoded = [System.Convert]::FromBase64String($TextString)
    }
    $Decoded
}