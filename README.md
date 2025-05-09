<div align='center'>
<img src='Assets/ProtectStrings.svg' />
</div>

ProtectStrings
==============

This is a module with a relative narrow purpose.  There are other options out there for encrypting entire files, or simply using Excel to encrypt an .xlsx, but I wanted the ability to encrypt string text that I'm working with at the CLI so I could write it to a file securely.
This was also an exercise in using AES encryption in Powershell.  The end result is a module that simplifies encrypting/decrypting string text using the built in DPAPI encryption or AES encryption with a 256-bit key derived from a supplied master password.

**WARNING**:

* This has been used mostly in PS v5.1 with limited testing in v7.5.  DPAPI functionality is prevented if the module is used on a non-Windows host.


## Getting Started

### Installing ProtectStrings
```powershell
# Powershell 5.1+
Install-Module ProtectStrings

# Import
Import-Module ProtectStrings
Get-Command -Module ProtectStrings
```

## Use Cases / Examples

### Setting Master Password
```powershell
PS> Set-MasterPassword
Enter Master Password: ****************
```

```powershell
# or provide a SecureString object
PS> $MasterPassword = Read-Host -AsSecureString
****************
PS> Set-MasterPassword -MasterPassword $MasterPassword
```

### Encrypt/Decrypt A String

```powershell
# encrypt a string using AES encryption
PS> Protect-String -InputString "my secret message" -Encryption AES
A7B3uXRDkDZkejQVQhwqn2I4KJjsxfqCbc1a+9Jgg620=
```

```powershell
# encrypt a string using the built-in DPAPI encryption. Windows only.
PS> Protect-String -InputString "my secret message" -Encryption DPAPI
DAQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAbkcdFfoRPkyh7LAp2HBlSgAAAAACAAAAAAADZgAAwAAAABAAAAB64FVTzSMWwdX0i3AyxkbjAAAAAASAAACgAAAAEAAAAJ6+QSsAWQHjhHM56iWeIIAYAAAAmV/Kpm7+Ojt+h4MTRXLN725F+E0ZIuIPFAAAAJDN1PB5Wu/8obtdAfzr2nQPg3YD?TE5JUEMyMjIxNTBMXFNZU1RFTQ==
```

```powershell
# Protect-String and Unprotect-String both accept pipe-line input
PS> "Secret message" | Protect-String -Encryption AES
A7B3uXRDkDZkejQVQhwqn2I4KJjsxfqCbc1a+9Jgg620=
```

```powershell
# Or the same example, but capture the output in a variable to decrypt later
PS> $encryptedtext = "Secret message" | Protect-String -Encryption AES
PS> $encryptedtext | Unprotect-String
Secret message
```

When protecting a string, Protect-String will choose AES by default.  If you provide the Encryption parameter you can select DPAPI as the value.  If no Master Password was set, you will be prompted to set one.

The output will be Base64 encoded cipher text either way.  Unprotect-String will automatically identify whether the cipher text was produced by AES or DPAPI and try to decrypt appropriately.
### Master Password/AES Key

The Master Password is used with PBKDF2 to generate a high-entropy 256-bit unique key for use with AES.  The key is stored as a SecureString object within the current session for repeated use.  If at any point you wish to clear it you can use the Remove-MasterPassword function to do so, or exit the session.

If you'd rather export the stored key to import later, rather than remembering the Master Password, you can use the Export-MasterPassword/Import-MasterPasword functions.  This might be helpful if you used some random password generator to create the Master Password to begin with.

The settings for the PBKDF2 have hard coded defaults, you can view them by running this command:
```powershell
PS> Get-AESKeyConfig

Name                           Value
----                           -----
Hash                           SHA256
Iterations                     600000
Salt                           fMK9w4HDtMO4d8Oa4pmAw6U+fknCqWvil4Q9w73DscOtw64=
```

These settings can be modified from the defaults using the Set-AESKeyConfig function.  See the Help info for details about how.  Any non-default settings are stored in an Environment variable for future use.

By changing any portion of the PBKDF2 settings using Set-AESKeyConfig the resulting key will be completely different even if the same password is provided.

### My Specific Example

The reason this module came to be was out of a somewhat narrow use-case.  I was performing an internal password audit, which was largely done using a Linux box and tools like John the ripper.  I wanted to hydrate the data with user information from Active Directory and perform other analysis that I was more comfortable doing in Powershell.  Wanting to do this on my normal workstation, but not wanting to have cracked passwords stored in the clear in CSV files I decided I would encrypt the password field, and decrypt it on the fly if I wanted to perform analysis.

I.e.
```powershell
$CSV = Import-Csv c:\temp\password_audit.csv
$CSV | Select-Object -First 5
```

```
User    Password                                                                                                                                Name            Department
----    --------                                                                                                                                ----            ----------
jsmith  AwGfd70iBoVkUUh0mq/HF4g2VVGmfqOB68zQFzhfD/cY=    John Smith      Accounting
bclark  AjR3gZNFKxYEqTKUNOQPEkfK43fxdTKluUzhUjrNmUmE=    Bob Clark       Human Resources
jkent   Abwb9NtTwnyyLm7vUMKmEgr4/QIUpnJUK7fcen4/sLP0=    James Kent      Information Technology
cdouglas AJyOYcDcx2E5mXrDkOisptvqnrr3Hcxm5eqwMD8KaGeY=   Corey Douglas   Accounting
bchester AUD3RQCSCQHWE13tVi2hQLs2jCkwmVevERYT7/cduurY=   Bill Chester    Facilities
```

Then while the CSV was loaded in to a variable (memory) I could loop through and use Unprotect-String to view the recovered passwords.  When I was done, I could use Protect-String again with AES encryption and the same Master Password, and then Export-CSV to save my work to file again.  All the while knowing that the sensitive data was encrypted within the file.  Are there other solutions out there? Probably, but this one was more fun and I got to make something.
