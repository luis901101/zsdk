The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes
- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 3.2.0+1 (2023-11-09)
### Added
- New `PRINTER_REBOOTED` value added to enum `ErrorCode`.
- New `rebootPrinterOverTCPIP` function added.

### Changed
- `printPdfFileOverTCPIP` function updated to abort printing and return `PRINTER_REBOOTED` error code when printer needs to be reboot to change the Virtual Device to PDF.

## 3.1.0+1 (2023-11-08)
### Added
- Added support for PDF Direct printing on printers using Link-OS v6.3 or later.
- Added Virtual Device settings to allow the user to change the Virtual Device configuration.
- Example project updated.

## 3.0.0+1 (2023-10-24)
### Added
- Added support of namespace property to support Android Gradle Plugin (AGP) 8. Projects with AGP < 4.2 should be compatible as well but it is highly recommended to update at least to AGP 7.0 or newer.

### Changed
- Example project updated to work with AGP 8

## 2.0.2+13 (2022-03-31)
## Changed
- Static iOS ZSDK lib included as Pod. It fixes [this issue](https://github.com/luis901101/zsdk/issues/1)  
- Example project updated to null-safety

## 2.0.1+12 (2021-09-14)
### Changed
- Android plugin API updated to support v2 Embedding while remaining compatible with apps that don’t use the v2 Android embedding.

## 2.0.0+11 (2021-05-08)
### Added
- Support for null safety.

### Changed
- Example updated with new features

## 1.0.6+10 (2020-10-12)
### Added
- Support for latest flutter frameworks

## 1.0.5+9
* Android ZPL print updated to send content in chunks, this way is better for big zpl templates
* iOS ZPL print updated to fix bug when printing big zpl templates

## 1.0.4+8
* Bug fixed when applying settings in Android.
* New read only setting added: resolution of the print head in dots per millimeter (dpmm)

## 1.0.3+7
* Support for printing configurations label.
* Minor bugs fixed.


## 1.0.2+5
* Support for custom timeout.
* Bug fixes in iOS connection exceptions


## 1.0.1+4
* Support for start manual calibration over TCP/IP.
* Support for getting and setting printer configurations over TCP/IP.
* Support for reset printer to default settings over TCP/IP.
* Support for ZPL printing (iOS and Android) over TCP/IP.
* Support for PDF printing (Android) over TCP/IP.