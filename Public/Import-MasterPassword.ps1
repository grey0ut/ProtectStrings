Function Import-MasterPassword {
    <#
    .Synopsis
    Import a previously exported master password from a text file
    .Description
    Function to import a previously exported master password keyfile and save it in the current session as the master password.
    .Parameter FilePath
    Destination full path (including file name) for the file containing the exported AES Key.
    .EXAMPLE
    PS C:\> Import-MasterPassword -FilePath C:\temp\keyfile.txt


    This will important the key from keyfile.txt and store it in the current Powershell session as the Master Password.
    .NOTES
    Version:        1.0
    Author:         C. Bodett
    Creation Date:  3/28/2022
    Purpose/Change: Initial function development
    #>
    [cmdletbinding()]
    Param (
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

    Begin {
        Try {
            Write-Verbose "Retreiving file content from: $FilePath"
            $EncodedKey = Get-Content -Path $FilePath -ErrorAction Stop
        } Catch {
            Write-Error $Error[0]
        }
    }

    Process {
        If ($EncodedKey) {
            $ClearTextAESKey = ConvertFrom-Base64 -TextString $EncodedKey
            Write-Verbose "Storing AES Key to current session"
            $SecureAESKey = ConvertTo-SecureString -String $ClearTextAESKey -AsPlainText -Force
            Set-AESMPVariable -MPKey $SecureAESKey
        }
    }

}