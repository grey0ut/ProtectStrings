<#
.Synopsis
Gets string from supplied input bytes
#>
Function ConvertFrom-Bytes{
        [cmdletbinding()]
        param(
        [Parameter(ValueFromPipeline=$true,Position=0,Mandatory=$true)]
        [Byte[]]$InputBytes,
        [Parameter(Position=1)]
        [ValidateSet('UTF8','Unicode')]
        [string]$Encoding = 'Unicode'
        )
    
        Write-Verbose "Converting from bytes to string using $Encoding encoding"
        $OutputString = [System.Text.Encoding]::$Encoding.GetString($InputBytes)
        $OutputString
    }
    