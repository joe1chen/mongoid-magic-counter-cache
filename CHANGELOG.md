# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- CI: test Mongoid 7.5 with Ruby driver 2.26 against MongoDB 8.0 (Ruby 2.7 / Rails 6.1).

## [2.0.0] - 2026-10-01
DOGOnews fork. Major version because the minimum supported Mongoid rose from none (1.1.3 accepted any version) to
7.0.

### Added
- Mongoid 7, 8 and 9 support (tested; no library changes were needed). On Mongoid 8+ an `:if_update` proc must read
  `previous_changes` instead of `changes`, because `changes` is already cleared in `after_update`.
- GitHub Actions test matrix (`.github/workflows/test.yml`), seven rows from Ruby 2.7 / Rails 6.1 /
  Mongoid 7.5 / MongoDB 6.0 to Ruby 3.4 / Rails 8.0 / Mongoid 9.0 / MongoDB 8.0. The `Gemfile` selects
  Rails and Mongoid from `RAILS_VERSION` / `MONGOID_VERSION` (defaults 6.1 / 7.5).
- GitHub Release workflow (`.github/workflows/release.yml`): pushing a `vX.Y.Z` tag creates a GitHub Release
  with this file's section as the notes.
- Spec that reloads the parent after destroying a child, so the decrement is checked against the database.

### Changed
- Runtime dependency `mongoid >= 7.0, < 10` (was any version).
- Specs run on RSpec 3.13 (keeping the `should` syntax, enabled explicitly); the embedded spec model uses
  `embedded_in` instead of `belongs_to`, and the `:if_update` spec models use `previous_changes` on Mongoid 8+.
- The gemspec `homepage` points to this fork.
- README rewritten for the maintained fork (supported versions, every option, when counters change); history
  moved to this file.

### Removed
- Travis CI configuration.

## [1.1.3] - 2018-06-01
### Added
- Mongoid 6 support (specs and Travis CI run against Mongoid 2–6).

### Changed
- Runtime dependency `mongoid-compatibility` (used by the specs to branch on the Mongoid version).

## [1.1.2] - 2018-06-01
### Changed
- `rake` is a development dependency instead of a runtime dependency.
- Increment/decrement code shared between the create/destroy and update callbacks; specs and Travis CI run against
  Mongoid 2–5, selected with `MONGOID_VERSION`.

## [1.1.1] - 2014-03-15
### Added
- `:if_update` option: together with `:if`, re-evaluates the condition after an update of a referenced or embedded
  document and increments or decrements the counter accordingly.

## [1.1.0] - 2014-03-03
### Added
- `:if` option: only count documents for which the proc returns true.
- Mongoid 4 support (`model_name.name`, `inc(field => n)`); counters on embedded documents are covered by specs.

### Changed
- The gemspec declares the MIT license.

## [1.0.0] - 2013-07-26
### Changed
- Runtime dependency `mongoid` without a version constraint (was `>= 2.2, <= 3.0`), so Mongoid 2.x, 3.x and Rails 4
  can be used. Breaks compatibility with Ruby 1.9.2 and older.

## [0.1.1] - 2012-07-09
### Changed
- Mongoid 3.0 support: runtime dependency `mongoid >= 2.2, <= 3.0` (was `~> 2.0`); `bson_ext` and `pry` are no
  longer dependencies.
- The default counter field name is demodulized and underscored (`Books::ForeignPublication` updates
  `foreign_publication_count`), not just downcased.

## [0.0.2] - 2012-02-27
### Added
- `magic_counter_cache`, an alias of `counter_cache`.

## [0.0.2.beta] - 2012-02-26
### Changed
- Runtime dependency `mongoid ~> 2.0` (was `2.2.6`).

## [0.0.1.beta] - 2012-02-26
### Added
- Initial release by Justin Herrick: `include Mongoid::MagicCounterCache` and `counter_cache :parent` increment a
  counter field on the referenced or embedding parent on create and decrement it on destroy; `:field` option.

[Unreleased]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v1.1.3...v2.0.0
[1.1.3]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v1.1.2...v1.1.3
[1.1.2]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v0.1.1...v1.0.0
[0.1.1]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v0.0.2...v0.1.1
[0.0.2]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v0.0.2.beta...v0.0.2
[0.0.2.beta]: https://github.com/joe1chen/mongoid-magic-counter-cache/compare/v0.0.1.beta...v0.0.2.beta
[0.0.1.beta]: https://github.com/joe1chen/mongoid-magic-counter-cache/releases/tag/v0.0.1.beta
