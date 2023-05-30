# Limitable

Limitable scans your ActiveRecord database schema for column size limits and defines corresponding model validations
so that you don't have to.

It aims to make your database schema the "one source of truth" about the maximum data sizes your columns can handle.
More practically, it removes the redundant need for explicit guards such as:

```ruby
validates :my_string_column, length: { less_than: 256 }

validates :my_integer_column, numericality: { less_than: 2_147_483_647 }

begin
  # ...
rescue ActiveRecord::ValueTooLong
  # ...
end
```

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add limitable
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install limitable
```

## Usage

Once included in a model, `Limitable` will scan `integer`, `string` and `text` columns for size limits
and define _byte size_ validations accordingly. Limits are configurable through `ActiveRecord` migrations.

### Quick Start

To enable these database limit validations globally:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include Limitable::Base

  # ...
end
```

To enable database limit validations on a per-model basis:

```ruby
class MyModel < ApplicationRecord
  include Limitable

  # ...
end
```

### SQL Adapters

`Limitable` is designed to be SQL adapter agnostic, however although some adapters have different default
default behaviors than others.

#### `mysql2`

MySQL/mariadb has and reports hard limits on all supported column types. As such, you won't need to specify explicit
limits in your database migrations/schema unless you want to change them from their default values.

#### `pg`

PostgreSQL has and reports hard limits on its integer columns, however it supports and defaults to unlimited
string/text columns. If you wish for limits to be set, they must be explicitly set in your database migrations/schema.

#### `sqlite3`

SQLite has hard limits on most of its column types, but it does not report them to active record. If you wish for limits
to be picked up, they must be explicitly set in your database migrations/schema.

## Development

- Run `bin/setup` to install dependencies.
- Run `bin/rake appraisal rspec` to run the tests.
- Run `bin/rake rubocop` to run the linter.
- Run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benmelz/limitable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
