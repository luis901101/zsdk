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