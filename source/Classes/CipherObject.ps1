Class CipherObject {
    [string]  $Encryption
    [string]  $CipherText
    hidden[string]  $DPAPIIdentity
    CipherObject ([string]$Encryption, [string]$CipherText) {
        $this.Encryption = $Encryption
        $this.CipherText = $CipherText
        $this.DPAPIIdentity = $null
    }
    [string] ToCompressed() {
        if ($this.Encryption -eq "AES") {
            return 'A{0}' -f $this.CipherText
        } else {
            $JSONBytes = [System.Text.Encoding]::UTF8.GetBytes($this.DPAPIIdentity)
            $EncodedOutput = [System.Convert]::ToBase64String($JSONBytes)
            return 'D{0}?{1}' -f $this.CipherText, $EncodedOutput
        }
    }
}