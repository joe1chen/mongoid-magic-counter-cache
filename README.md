# mongoid-magic-counter-cache

[![CI RSpec Test](https://github.com/joe1chen/mongoid-magic-counter-cache/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/joe1chen/mongoid-magic-counter-cache/actions/workflows/test.yml)

Counter caches for **Mongoid** documents. Include `Mongoid::MagicCounterCache` in a child document, declare
`counter_cache :parent`, and an integer field on the parent is incremented when a child is created and
decremented when it is destroyed (optionally only when a condition holds). Works for both referenced
(`belongs_to`) and embedded (`embedded_in`) children; the parent is updated with an atomic `$inc`.

This is the [DOGOnews](https://www.dogonews.com)-maintained fork of
[jah2488/mongoid-magic-counter-cache](https://github.com/jah2488/mongoid-magic-counter-cache) (upstream has been
inactive since 2015, though not archived). It is kept working on current Ruby, Rails, Mongoid and MongoDB versions.

## Supported versions

Tested on every push by the [GitHub Actions matrix](https://github.com/joe1chen/mongoid-magic-counter-cache/actions/workflows/test.yml)
([workflow](.github/workflows/test.yml)):

| Ruby | Rails | Mongoid | MongoDB |
|---|---|---|---|
| 2.7 | 6.1 | 7.5 | 6.0 |
| 3.0 | 6.1 | 8.0 | 6.0 |
| 3.1 | 7.0 | 8.1 | 7.0 |
| 3.2 | 7.1 | 8.1 | 7.0 |
| 3.2 | 7.2 | 9.0 | 7.0 |
| 3.3 | 7.2 | 9.0 | 8.0 |
| 3.4 | 8.0 | 9.0 | 8.0 |

The gemspec allows `mongoid >= 7.0, < 10`.

## Installation

This fork is not published to RubyGems; install it from GitHub. The gem name is `mongoid_magic_counter_cache`:

```ruby
# Gemfile
gem 'mongoid_magic_counter_cache', github: 'joe1chen/mongoid-magic-counter-cache'
```

Then `bundle install`.

## Usage

### Referenced documents

Add an integer field for the counter to the parent:

```ruby
class Library
  include Mongoid::Document

  field :book_count, type: Integer, default: 0
  has_many :books
end
```

Include `Mongoid::MagicCounterCache` in the child and name the association to count against:

```ruby
class Book
  include Mongoid::Document
  include Mongoid::MagicCounterCache

  belongs_to    :library
  counter_cache :library
end
```

```ruby
library.books.create(title: "War and Peace")
library.book_count # => 1
```

The default counter field is `<child model name, demodulized and underscored>_count`, so `Book` updates
`book_count` and `Books::ForeignPublication` updates `foreign_publication_count`. For a referenced parent the
counter must be a declared `field` on the parent class; otherwise nothing is incremented.

`magic_counter_cache` is an alias of `counter_cache`, for models where that name clashes.

### Embedded documents

The same declaration works for an embedded child; the counter is updated on the embedding parent (`_parent`):

```ruby
class Book
  include Mongoid::Document

  field :page_count, type: Integer, default: 0
  embeds_many :pages
end

class Page
  include Mongoid::Document
  include Mongoid::MagicCounterCache

  embedded_in   :book
  counter_cache :book
end
```

### Custom field name

```ruby
counter_cache :library, field: "total_amount_of_books"
```

### Conditional counter (`:if`)

Only count children for which a proc returns true:

```ruby
class Post
  include Mongoid::Document

  field :comment_count, type: Integer, default: 0
  has_many :comments
end

class Comment
  include Mongoid::Document
  include Mongoid::MagicCounterCache

  belongs_to :post

  field :is_published, type: Boolean, default: false

  counter_cache :post, if: ->(comment) { comment.is_published }
end
```

`comment_count` is incremented on create and decremented on destroy only when the `:if` proc returns true.

### Re-evaluating the condition on update (`:if_update`)

By default an update never changes the counter. Pass `:if_update` together with `:if` to re-evaluate after an
update: when `:if_update` returns true, the counter is incremented if `:if` is now true and decremented if it is
now false. Typically `:if_update` checks whether the field used by `:if` changed in that save:

```ruby
# Mongoid 8 and 9
counter_cache :post,
              if:        ->(comment) { comment.is_published },
              if_update: ->(comment) { comment.previous_changes['is_published'] }

# Mongoid 7
counter_cache :post,
              if:        ->(comment) { comment.is_published },
              if_update: ->(comment) { comment.changes['is_published'] }
```

Since Mongoid 8, `changes` is already cleared when `after_update` callbacks run, so the change must be read
from `previous_changes`. `:if_update` without `:if` is ignored.

### When counters change

Counters are updated from the child's `after_create`, `after_destroy` and (with `:if_update`) `after_update`
callbacks. Operations that skip callbacks (`delete`, `delete_all`, `update_all`, …) and moving a child to a
different parent do not adjust the counters.

## Development

```bash
# needs a MongoDB on localhost:27017 (e.g. docker run -p 27017:27017 mongo:8.0)
MONGOID_VERSION=9.0 RAILS_VERSION=8.0 bundle install
MONGOID_VERSION=9.0 RAILS_VERSION=8.0 bundle exec rspec spec
```

`MONGOID_VERSION` and `RAILS_VERSION` select the versions in the `Gemfile` (defaults: Mongoid 7.5, Rails 6.1).
To add a combination to CI, add a row to `matrix.include` in `.github/workflows/test.yml`.

## History

See [CHANGELOG.md](CHANGELOG.md).

- **1.1.3+ (DOGOnews fork)** — Mongoid 6–8 support (2018–2022); GitHub Actions matrix up to Ruby 3.4 / Rails 8.0 /
  Mongoid 9.0 / MongoDB 8.0 (2026).
- **1.1.1** — `:if_update` option.
- **Original** — by Justin Herrick.

## Credits

- Justin Herrick — original author
- [Contributors](https://github.com/joe1chen/mongoid-magic-counter-cache/graphs/contributors)

Copyright (c) 2011 Justin Herrick. Licensed under the MIT license (see [LICENSE](LICENSE)).
