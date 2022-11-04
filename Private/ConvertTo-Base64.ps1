<#
.Synopsis
Converts a plaintext string in to Base64.
.Description
Takes a plaintext string as a parameter, either directly or from the pipeline, and converts it in to Base64.
.Parameter TextString
The plaintext string. Can come from the pipeline.
.Parameter Encoding
Default encoding is UTF8, but this can be Unicode or UTF8 if you're having problems.
.NOTES
Version:        1.0
Author:         C. Bodett
Creation Date:  9/14/2021
Purpose/Change: Initial function development.
#>
Function ConvertTo-Base64{
    [cmdletbinding()]
    Param (
        [Parameter(ValueFromPipeline = $true, Position = 0, Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$TextString,
        [Parameter(ValueFromPipeline = $false, Position = 0, Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Byte[]]$Bytes,
        [Parameter(Position = 1)]
        [ValidateSet('UTF8','Unicode')]
        [String]$Encoding = 'UTF8'
    )

    Switch ($PSBoundParameters.Keys) {
        'TextString' {
            $Encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::$Encoding.GetBytes($TextString))
        }
        'Bytes' {
            $Encoded = [System.Convert]::ToBase64String($Bytes)
        }
    }
    return $Encoded
}
