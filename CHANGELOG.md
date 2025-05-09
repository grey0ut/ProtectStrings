# Changelog for ProtectStrings

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

- changed Remove-MasterPassword to Clear-MasterPassword
- changed RNG from RNGCryptoServiceProvider to RandomNumberGenrator

### Fixed

- satisfied PSScriptAnalyzer tests

### Removed

- removed several private functions that ultimately are unnecessary and require additional pester tests
- Private function Clear-AESMPVariable
- Private function ConvertFrom-Byte
- Private function ConvertTo-Byte
- Private function ConvertTo-Base64
- Private function ConvertFrom-Base64
- Private function Get-AESMPVariable
- Private function Get-RandomByte
- Private function New-AESCipher
- Private function Set-AESMPVariable