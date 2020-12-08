# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.2] - 2020-12-08

### Fixed

- Update Sidekiq config for Heroku.

## [0.5.1] - 2020-12-08

### Changed

- Add Tag selects to user TimeRange form

## [0.5.0] - 2020-12-03

### Added

- Add Tag to TimeRange.
- Add TagType#active_for_activities.
- Add TagType#active_for_time_ranges.

### Changed

- Rename ActivityTag to TagAssociation.
- Show all ancestors in tag names.

## [0.4.1] - 2020-12-03

### Fixed

- Spec warning.

## [0.4.0] - 2020-12-03

### Added

- Tags on plans update depending on parent tag selected.
- Safety validations when working with tags.

## [0.3.0] - 2020-11-27

### Added

- Self join on Tag.

## [0.2.0] - 2020-11-27

### Added

- UI to add tags to activities.

## [0.1.0] - 2020-11-26

### Added

- Versioning!
- Changelog!
