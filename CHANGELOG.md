# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.0] - 2021-03-16

### Changed

- Use HAML insted ERB templates

## [0.9.12] - 2021-02-26

### Added

- Summary and Data views for Team Individual

## [0.9.11] - 2021-02-26

### Added

- Filter applies to bar chart and table on Team Individuals page

## [0.9.10] - 2021-02-22

### Added

- Weekly option on line chart

## [0.9.9] - 2021-02-12

### Added

- UserGroup and Membership API endpoints
- Add filter[email] to api/v1/users

### Fixed

- Show correct stats in report cards


## [0.9.8] - 2021-02-05

### Added

- Planned vs Actual on Team Dashboard line graph

## [0.9.7] - 2021-02-04

### Added

- TagType and Tag API endpoints

## [0.9.6] - 2021-01-26

### Added

- Script to generate .env file.

## [0.9.5] - 2021-01-25

### Added

- Ruby 3
- Support for Devise login
- User and TimeRange API endpoints
- Default Filter Tags

## [0.9.3] - 2021-01-14

### Fixed

- Don't show 'days' in readable times (just hours and minutes)

## [0.9.2] - 2021-01-14

### Added

- Team leads access team job plans.
- Admins to see all job plans under the admin section.

### Fixed

- User dashboard to show just your own job plans and any to sign off.

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
