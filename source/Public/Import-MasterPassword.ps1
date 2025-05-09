function Import-MasterPassword {
    <#
    .SYNOPSIS
    Import a previously exported master password from a text file
    .DESCRIPTION
    Function to import a previously exported master password keyfile and save it in the current session as the master password.
    .PARAMETER FilePath
    Destination full path (including file name) for the file containing the exported AES Key.
    .EXAMPLE
    PS C:\> Import-MasterPassword -FilePath C:\temp\keyfile.txt


    This will important the key from keyfile.txt and store it in the current Powershell session as the Master Password.
    #>
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Necessary')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [validatescript({
            if( -not ($_ | test-path) ){
                throw "File does not exist"
                }
            if(-not ( $_ | test-path -PathType Leaf) ){
                throw "The -FilePath argument must be a file"
                }
                return $true
        })]
        [Alias('Path')]
        [System.IO.FileInfo]$FilePath
    )

    begin {
        try {
            Write-Verbose "Retreiving file content from: $FilePath"
            $EncodedKey = Get-Content -Path $FilePath -ErrorAction Stop
        } catch {
            Write-Error $_
        }
    }

    process {
        if ($EncodedKey) {
            $ClearTextAESKey = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedKey))
            Write-Verbose "Storing AES Key to current session"
            $SecureAESKey = ConvertTo-SecureString -String $ClearTextAESKey -AsPlainText -Force
            New-Variable -Name "AESMP" -Value $SecureAESKey -Option AllScope -Scope Global -Force
        }
    }
}