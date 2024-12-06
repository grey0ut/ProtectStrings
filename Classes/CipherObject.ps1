Class CipherObject {
    [String]  $Encryption
    [String]  $CipherText
    hidden[String]  $DPAPIIdentity
    CipherObject ([String]$Encryption, [String]$CipherText) {
        $this.Encryption = $Encryption
        $this.CipherText = $CipherText
        $this.DPAPIIdentity = $null
    }
    [String] ToCompressed() {
        if ($this.Encryption -eq "AES") {
            return 'A{0}' -f $this.CipherText
        } else {
            $JSONBytes = ConvertTo-Bytes -InputString $this.DPAPIIdentity -Encoding UTF8
            $EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
            return 'D{0}?{1}' -f $this.CipherText, $EncodedOutput
        }
    }
}