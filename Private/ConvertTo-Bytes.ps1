<#
.Synopsis
Gets bytes from supplied input string
#>
Function ConvertTo-Bytes{
    [cmdletbinding()]
    param(
    [Parameter(ValueFromPipeline=$true,Position=0,Mandatory=$true)]
    [string]$InputString,
    [Parameter(Position=1)]
    [ValidateSet('UTF8','Unicode')]
    [string]$Encoding = 'Unicode'
    )

    Write-Debug "Converting Input text to bytes with $Encoding encoding"
    Write-Debug "Input Text: $InputString"
    $Bytes = [System.Text.Encoding]::$Encoding.GetBytes($InputString)
    return $Bytes
}
