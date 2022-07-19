Function ConvertFrom-SecureStringToPlainText {
    [cmdletbinding()]
    param(
        [parameter(Position=0,HelpMessage="Must provide a SecureString object",
        ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNull()]
        [System.Security.SecureString]$StringObj
        )
    Process {
        $BSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($StringObj)
        $PlainText = [Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    }
    End {
        $PlainText
    }
} 