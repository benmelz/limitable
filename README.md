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

Once included in a model, `Limitable` will scan `integer`, `string`, `text` and `binary` columns for size limits,
defining byte size validations accordingly. Limits are configurable through `ActiveRecord` migrations.

### Quick Start

To enable database limit validations globally:

```ruby
class ApplicationRecord < ActiveRecord::Base
  extend Limitable::Base

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

### Translations

`Limitable` ships with i18n support for its validation error messages. Each column type has its own translation key,
outlined alongside their default values in `lib/limitable/locale/en.yml`.

Each validator will pass a `limit` parameter (min/max integer for integer columns, bytes for string/text/binary),
which can be used to make the messages less ambiguous if desired.

e.g.

```yaml
en:
  limitable:
    string_limit_exceeded: "may not exceed %{limit} characters"
```

### SQL Adapters

`Limitable` is designed to be SQL adapter agnostic, however different adapters have different default behaviors that
affect their integration with this library.

#### `mysql2`

MySQL/mariadb has and reports hard limits on all supported column types. As such, you won't need to specify explicit
limits in your database migrations/schema unless you want to change them from their default values.

#### `pg`

PostgreSQL has and reports hard limits on its integer columns, however it supports and defaults to unlimited
string/text/binary columns. If you wish for limits to be validated on those columns, they must be explicitly set in your
database migrations/schema.

#### `sqlite3`

SQLite has hard limits on most of its column types, but it does not report them to active record. If you wish for limits
to be validated, they must be explicitly set in your database migrations/schema.

## Development

- Run `bin/setup` to install dependencies.
- Run `bin/rake appraisal rspec` to run the tests.
- Run `bin/rake rubocop` to run the linter.
- Run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benmelz/limitable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
