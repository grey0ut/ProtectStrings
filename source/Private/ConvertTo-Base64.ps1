function ConvertTo-Base64 {
    <#
    .SYNOPSIS
    Converts a plaintext string in to Base64.
    .DESCRIPTION
    Takes a plaintext string as a parameter, either directly or from the pipeline, and converts it in to Base64.
    .PARAMETER TextString
    The plaintext string to be converted in to Base64
    .PARAMETER Bytes
    Byte(s) to convert in to Base64
    .PARAMETER Encoding
    Default encoding is UTF8, but this can be Unicode or UTF8 if you're having problems.
    .EXAMPLE
    ConvertTo-Base64 -TextString "some text"
    #>
    [cmdletbinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$TextString,
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [byte[]]$Bytes,
        [Parameter(Position = 1)]
        [ValidateSet('UTF8','Unicode')]
        [string]$Encoding = 'UTF8'
    )

    switch ($PSBoundParameters.Keys) {
        'TextString' {
            $Encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::$Encoding.GetBytes($TextString))
        }
        'Bytes' {
            $Encoded = [System.Convert]::ToBase64String($Bytes)
        }
    }
    return $Encoded
}