## Unreleased (DOGOnews fork)

* GitHub Actions CI matrix from Ruby 2.7 / Rails 6.1 / Mongoid 7.5 / MongoDB 6.0 up to Ruby 3.4 / Rails 8.0 / Mongoid 9.0 / MongoDB 8.0; Travis config removed.
* mongoid dependency bounded to `>= 7.0, < 10`; RSpec 3.13 for the specs.
* README rewritten for the maintained fork; gemspec homepage points at joe1chen/mongoid-magic-counter-cache.

## v1.1.3 (DOGOnews fork)

* Support for Mongoid 6, 7 and 8 (`:if_update` procs must read `previous_changes` on Mongoid 8+).

## v1.1.1

* Add :if_update option in order to allow counter to be conditionally increment/decrement counter when an update is made to a referenced/embedded object.

## v1.0.0

* Remove version dependency to work with rails 4. Breaks compatibility with ruby 1.9.2 and older

## v0.1.1

* Multiple Merge requests to improve functionality and version support

## v0.0.1

* Initial Release
