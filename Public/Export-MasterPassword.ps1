Function Export-MasterPassword {
    <#
    .Synopsis
    Export the currently set Master Password to a text file
    .Description
    Function to retrieve the currently set master password and export it to a text file for transportation between systems or backup. 
    Similar in end result to generating an AES key and saving it to file.
    .Parameter FilePath
    Destination full path (including file name) for exported AES Key.
    .EXAMPLE
    PS C:\> Export-MasterPassword -FilePath C:\temp\keyfile.txt


    this will convert the current session AES key from a SecureString object to its raw byte values, encode in Base64
    and export it to a file called keyfile.txt
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
            if( -not ($_.DirectoryName | test-path) ){
                throw "Folder does not exist"
                }
                return $true
        })]
        [Alias('Path')]
        [System.IO.FileInfo]$FilePath
    )

    Begin {
        $SecureAESKey = Try {
            $Global:AESMP
        } Catch {
            # do nothing
        }
    }

    Process {
        if ($SecureAESKey) {
            Write-Verbose "Stored AES key found"
            $ClearTextAESKey = ConvertFrom-SecureStringToPlainText $SecureAESKey
            $AESKey = ConvertTo-Bytes -InputString $ClearTextAESKey -Encoding Unicode
            Write-Verbose "Converting to Base64 before export"
            $EncodedKey = [System.Convert]::ToBase64String($AESKey)
            Write-Verbose "Saving to $Filepath with Encoded key:"
            Write-Debug "$EncodedKey"
            Out-File -FilePath $FilePath -InputObject $EncodedKey -Force
        } else {
            Write-Warning "No key found to export"
        }
    }

}