@{

# Script module or binary module file associated with this manifest.
RootModule = 'ProtectStrings.psm1'

# Version number of this module.
ModuleVersion = '1.26.5'

# Supported PSEditions
CompatiblePSEditions = @("Desktop","Core")

# ID used to uniquely identify this module
GUID = '77540977-3d48-4b63-8d74-d7cd5ac8a457'

# Author of this module
Author = 'Courtney Bodett'

# Company or vendor of this module
CompanyName = 'Grey0ut'

# Copyright statement for this module
Copyright = '(c) 2021 Courtney Bodett. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Protect string text with DPAPI or AES encryption'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Export-MasterPassword', 'Get-AESKeyConfig', 'Get-MasterPassword', 
               'Import-MasterPassword', 'Protect-String', 'Remove-MasterPassword', 
               'Set-AESKeyConfig', 'Set-MasterPassword', 'Unprotect-String'


# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('string','encryption','dpapi','aes','PSEdition_Desktop','Windows')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/grey0ut/ProtectStrings/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/grey0ut/ProtectStrings'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

