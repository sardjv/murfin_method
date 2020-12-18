# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.1] - 2020-12-18

### Added

- Add time filter to bar chart.

## [0.9.0] - 2020-12-18

### Added

- Add tag filter to line graph.
- Add random seed for tags.

## [0.8.1] - 2020-12-16

### Fixed

- Always show full month data on line graph.
- Prevent server error when viewing graph with missing actuals.

## [0.8.0] - 2020-12-16

### Added

- Add date selects for line graph.

## [0.7.1] - 2020-12-15

### Changed

- Remove user TimeRanges UI.
- Clean up couple of translations.

## [0.7.0] - 2020-12-15

### Added

- Add Pundit for authorization.
- Authorize Plan and Signoff controllers.
- Allow admins and signoffs to index plans.
- Hide Plan and Signoff actions if not authorized.

## [0.6.2] - 2020-12-11

### Fixed

- Show duration errors on plans.

## [0.6.1] - 2020-12-11

### Added

- Add default signoff of current user to new plans.

## [0.6.0] - 2020-12-11

### Added

- Add signoffs to plans.

## [0.5.3] - 2020-12-08

### Changed

- Show activities in a table.

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
