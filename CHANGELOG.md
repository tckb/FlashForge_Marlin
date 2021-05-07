# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.8.2] - 2021-04-21

### Added
- Enabled G26 Mesh Validation patterns
  - enabled g26 in order to test the mesh bed leveling
  
### Changed

- Updated the mesh inset to fit the bed
  - with an inset 20 the 3rd grid wouldn't fit the bed, updated it to 5.

### Fixed

#### Inventor, Dreamer
- Extruder swap wouldn't properly because of missing definition, this has been fixed.  


## [0.8.1] - 2021-04-16

### Added
- Print time Enhancements

  - Printer should now show the remaining time/elapsed time 
  - Enabled 'M73' to show remaining time (useful when you have octoprint) 
  - Show print progress bar during print

- Added predefined presets for "PLA+"

- Better build information in firmware
   - added machine name and build information in 'Version.h'
   - This information is already available in "Info>PrinterInfo"

#### Inventor
- Enabled Power-loss recovery
    
### Changed
#### Dreamer Nx

- Updated Nozzle park position (G27) to 'Back Right' co-ordinates
    - current position is (X_MAX_POS - 10), (Y_MAX_POS - 10)

## [0.8.0] - 2021-04-14
### Added

- LCD display improvements
    - added scrolling status when there's long status is shown
    - enabled support to show progress (M73) so that it can be used in Octoprint

## [0.7.1] - 2021-04-13
No significant changes

[Unreleased]: https://github.com/tckb/FlashForge_Marlin/compare/v0.8.2...fork_main

