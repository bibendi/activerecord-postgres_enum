[![Gem Version](https://badge.fury.io/rb/activerecord-postgres_enum.svg)](https://badge.fury.io/rb/activerecord-postgres_enum)
[![Build Status](https://github.com/bibendi/activerecord-postgres_enum/workflows/Ruby/badge.svg?branch=master)](https://github.com/bibendi/activerecord-postgres_enum/actions?query=branch%3Amaster)

# ActiveRecord::PostgresEnum

Adds migration and schema.rb support to PostgreSQL enum data types.

<a href="https://evilmartians.com/?utm_source=activerecord-postgres_enum">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-postgres_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-postgres_enum

## Usage

### Migrations

```ruby
create_enum :mood, %w(happy great been_better)

create_table :person do
  t.enum :person_mood, enum_name: :mood
end
```

Running the above will create a table :person, with a column :person_mood of type :mood. This will also be saved on schema.rb so that `rake schema:load` works as expected.

To drop an existing enum:

```ruby
drop_enum :mood
```

To rename an existing enum:

```ruby
rename_enum :mood, :emotions
```

To add a value into existing enum:

```ruby
add_enum_value :mood, "pensive"
```

To remove a value from existing enum:

> :warning: Make sure that value is not used anywhere in the database.

```ruby
remove_enum_value :mood, "pensive"
```

To add a new enum column to an existing table:

```ruby
def change
  create_enum :product_type, %w[one-off subscription]

  add_column :products, :type, :product_type
end
```

To rename a value:

```ruby
rename_enum_value :mood, "pensive", "wistful"
```

**NB:** To stop Postgres complaining about adding enum values inside a transaction, use [`disable_ddl_transaction!`](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-disable_ddl_transaction-21) in your migration.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bibendi/activerecord-postgres_enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::PostgresEnum project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bibendi/activerecord-postgres_enum/blob/master/CODE_OF_CONDUCT.md).
