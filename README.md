ProtectStrings
==============  

This is a module with a relative narrow purpose.  There are other options out there for encrypting entire files, or simply using Excel to encrypt an .xlsx, but I wanted the ability to encrypt string text that I'm working with at the CLI so I could write it to a file securely.  
This was also an exercise in using AES encryption in Powershell.  The end result is a module that simplifies encrypting/decrypting string text using the built in DPAPI encryption or AES encryption with a 256-bit key derived from a supplied master password.  
  
**WARNING**:

* This has only been tested in Powershell v5.1.  
  

## Getting Started  
  
### Installing ProtectStrings  
```powershell  
# Powershell 5
Install-Module ProtectStrings  
  
# Import  
Import-Module ProtectStrings  
Get-Command -Module ProtectStrings  
```  
  
## Use Cases / Examples  
  
### Setting Master Password  
```powershell  
Set-MasterPassword
```  
```  
Enter Master Password: ****************  
```  
  
```powershell
# or provide a SecureString object  
$MasterPassword = Read-Host -AsSecureString  
```  
```  
****************  
```  
  
```powershell
Set-MasterPassword -MasterPassword $MasterPassword  
```  

### Encrypt/Decrypt A String  
  
```powershell
# encrypt a string using AES encryption  
Protect-String -InputString "my secret message" -Encryption AES  
```  
  
```  
eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IlhuVmVSTTNMS3A3MU80bTkwdEREV1pvdmRkRTZ5TWl5WnFNNGM5bHgyWWxMdWc1Z3JmR3p0elB6ZzVhMG1YMWMiLCJEUEFQSUlkZW50aXR5IjoiIn0=  
```  
    
```powershell
# encrypt a string using the built-in DPAPI encryption  
Protect-String -InputString "my secret message"  
```  
  
```  
eyJFbmNyeXB0aW9uIjoiRFBBUEkiLCJDaXBoZXJUZXh0IjoiMDEwMDAwMDBkMDhjOWRkZjAxMTVkMTExOGM3YTAwYzA0ZmMyOTdlYjAxMDAwMDAwNzNhN2VmN2U2ODMzOTg0ZTg3Nzg2NTA0ZjlhMjFjMTkwMDAwMDAwMDAyMDAwMDAwMDAwMDEwNjYwMDAwMDAwMTAwMDAyMDAwMDAwMGI0NDlhYmJlZGI1ZWY3NzkwNGU4NWYxNGIyNGM1ZmNiYmFmMmVhYmJhNGY3MjAzYzg2YTNiOGM0MDY0N2Q2NzMwMDAwMDAwMDBlODAwMDAwMDAwMjAwMDAyMDAwMDAwMDBlYjNiNTBmZTVkZGEyNWNiNzdjZmQzOTlmYTVjNGZkOTBmNGMxMjgxOTRiYjEwMjYwZDRmZjk3MGMwZjZmYWEzMDAwMDAwMGE4NDlmY2QzZTVmMjFlZTQxMzE5Yjc2ZDk1MzM4N2E2YjUyM2U1YWFiNmQ5MmE0YTlmMTU3MjNhYmYwZWMwN2YzMGJjMWFkZjEyNWRjNDA2MmRmNTIxYzQwMTY5ZjVmMzQwMDAwMDAwOWM0ODRmMWIxMzE1MjkxY2Y0ZDU1Y2U1MTdmNWZmMWQ0MDQyZmI0MDRjZjBiNGM4M2ZhNWY3MjIwZGJiYjI3ODEwYWRkMmNmNjJhNDg3ZGQ5MjBmMGE4YWUxMTY3ZTVjMzAzZjEyMWM3ZjgyY2RlNzdmZTRmOTMyMDc5MTI0OTciLCJEUEFQSUlkZW50aXR5IjoiR1JJU0xPQk9cXENvdXJ0bmV5IEJvZGV0dCJ9  
```  
  
```powershell  
# Protect-String and Unprotect-String both accept pipe-line input  
"Secret message" | Protect-String -Encryption AES  
```  
  
```
eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IlhDdnZwcUoxdm90OU9UQ0RFTkxRWkFPSk1zSDFFcjJJTXFiemdWaUpBU1U9IiwiRFBBUElJZGVudGl0eSI6IiJ9  
```  

```powershell
# Or the same example, but capture the output in a variable to decrypt later  
$encryptedtext = "Secret message" | Protect-String -Encryption AES  
$encryptedtext | Unprotect-String  
```  
  
```  
Secret message  
```  
  
When protecting a string, Protect-String will choose DPAPI by default.  If you provide the Encryption parameter you can select AES as the value.  If no Master Password was set, you will be prompted to set one.  
  
The output will be Base64 encoded cipher text either way.  Unprotect-String will automatically identify whether the cipher text was produced by AES or DPAPI and try to decrypt appropriately.  
### Master Password/AES Key
  
The Master Password is used with PBKDF2 to generate a high-entropy 256-bit unique key for use with AES.  The key is stored as a SecureString object within the current session for repeated use.  If at any point you wish to clear it you can use the Remote-MasterPassword function to do so, or exit the session.  
  
If you'd rather export the stored key to import later, rather than remembering the Master Password, you can use the Export-MasterPassword/Import-MasterPasword functions.  This might be helpful if you used some random password generator to create the Master Password to begin with.  
  
The settings for the PBKDF2 have hard coded defaults, you can view them by running this command:  
```powershell  
Set-AESKeyConfig -Verbose  
```  
  
```  
VERBOSE: Config file path: C:\Users\Courtney Bodett\AppData\Local\ProtectStringsConfig.psd1
VERBOSE: 
        Saving settings...
        Salt........: |Â½ÃÃ´Ã¸wÃšâ™€Ã¥>~IÂ©kâ—„=Ã½Ã±Ã­Ã®
        Iterations..: 310000
        Hash........: SHA256
```  
  
These settings can be modified by altering the text file at that path (noting that Salt and Hash should be wrapped in single quotes) or by using the Set-AESKeyConfig (preferred).  Iterations, Salt, and Hash are all parameters of Set-AESKeyConfig and it has a validated set of hash algorithms you can provide and verifies that the provided salt is at least 8 bytes in length.  For best error handling, use Set-AESKeyConfig.  
  
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
jsmith  eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6Im9UYituVFQ1Y005d09ZZTM5UGJVenMzZzY2dzYwYkRCZHFMamYwdCtVY009IiwiRFBBUElJZGVudGl0eSI6IiJ9    John Smith      Accounting
bclark  eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6ImdMYUJ6RWhpNytobHpEaExpSlY4YTA3VXhUL1V3aUZ0RTNrb3ZzVWtUSWM9IiwiRFBBUElJZGVudGl0eSI6IiJ9    Bob Clark       Human Resources  
jkent   eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6IllhZ2NVdFdvYTZMOW5JVEhKMDM0b0pqeEROU2FIbEtONUJHMmltbGN2NnM9IiwiRFBBUElJZGVudGl0eSI6IiJ9    James Kent      Information Technology  
cdouglas eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6InUyblhVSFlqbkEwUE9KbUpBek1Gd2k1U0orWndJQ3gxUjlQdHIxY0h6K2s9IiwiRFBBUElJZGVudGl0eSI6IiJ9   Corey Douglas   Accounting  
bchester eyJFbmNyeXB0aW9uIjoiQUVTIiwiQ2lwaGVyVGV4dCI6Ijc2Ui9oNEFOR1Q1dTNVSnpyd1RxN3h3SzdENEpTSEU2L1N2Mlo2aEx0dmc9IiwiRFBBUElJZGVudGl0eSI6IiJ9   Bill Chester    Facilities
```  
  
Then while the CSV was loaded in to a variable (memory) I could loop through and use Unprotect-String to view the recovered passwords.  When I was done, I could use Protect-String again with AES encryption and the same Master Password, and then Export-CSV to save my work to file again.  All the while knowing that the sensitive data was encrypted within the file.  Are there other solutions out there? Probably, but this one was more fun and I got to make something.  