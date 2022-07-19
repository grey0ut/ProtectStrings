Class CipherObject {
    [String]  $Encryption
    [String]  $CipherText
    hidden[String]  $DPAPIIdentity
    CipherObject ([String]$Encryption, [String]$CipherText) {
        $this.Encryption = $Encryption
        $this.CipherText = $CipherText
        $this.DPAPIIdentity = $null
    }
}