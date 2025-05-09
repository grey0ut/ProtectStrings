BeforeAll {
    Import-Module $ModuleName
}

Describe 'Convert-HexStringToByteArray' {
    It 'Should convert this format: 0x41,0x42,0x43,0x44' {
        InModuleScope $ModuleName {
            try {
                $Bytes = Convert-HexStringToByteArray -HexString '0x41,0x42,0x43,0x44'
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Failed | Should -BeFalse
            $Bytes.GetType().BaseType -eq [System.Array] | Should -BeTrue
            $Bytes[0].GetType().Name -eq "Byte" | Should -BeTrue
            $Bytes.Count -eq 4 | Should -BeTrue
        }
    }
    It 'Should convert this format: \x41\x42\x43\x44' {
        InModuleScope $ModuleName {
            try {
                $Bytes = Convert-HexStringToByteArray -HexString '\x41\x42\x43\x44'
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Failed | Should -BeFalse
            $Bytes.GetType().BaseType -eq [System.Array] | Should -BeTrue
            $Bytes[0].GetType().Name -eq "Byte" | Should -BeTrue
            $Bytes.Count -eq 4 | Should -BeTrue
        }
    }
    It 'Should convert this format: 41-42-43-44' {
        InModuleScope $ModuleName {
            try {
                $Bytes = Convert-HexStringToByteArray -HexString '41-42-43-44'
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Failed | Should -BeFalse
            $Bytes.GetType().BaseType -eq [System.Array] | Should -BeTrue
            $Bytes[0].GetType().Name -eq "Byte" | Should -BeTrue
            $Bytes.Count -eq 4 | Should -BeTrue
        }
    }
    It 'Should convert this format: 41424344' {
        InModuleScope $ModuleName {
            try {
                $Bytes = Convert-HexStringToByteArray -HexString '41424344'
                $Failed = $false
            } catch {
                $Failed = $true
            }
            $Failed | Should -BeFalse
            $Bytes.GetType().BaseType -eq [System.Array] | Should -BeTrue
            $Bytes[0].GetType().Name -eq "Byte" | Should -BeTrue
            $Bytes.Count -eq 4 | Should -BeTrue
        }
    }
}