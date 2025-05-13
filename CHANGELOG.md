# Changelog for ProtectStrings

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- DPAPI required manually adding System.Security assembly type on v5.1
- AES encryption wasn't automatically asking for password when no password was present
