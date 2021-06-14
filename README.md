# Botrb

This is just a library to make a simple IRC bot. At this time, consider it to be barely alpha quality.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'botrb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install botrb

## Usage

After installing the gem via some method (mentioned above), do something like the following:

```ruby
require 'Botrb'

config = {
  name: 'mybot',
  host: 'irc.libera.chat',
  port: 6667
}

bot = Botrb::Bot.new config

# Alternatively, you can setup the bot thusly:

bot = Botrb::Bot.new do |b|
  b.name = 'mybot'
  b.host = 'irc.freenode.com'
  b.port = 6667
end

# Start the bot's main thread
bot.run

# Join a channel
bot.join 'test-channel'

# Join a private channel
bot.join 'secured-channel here_is_my_password'
```

TODO: Add classes and documentation for handlers...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Fork this repo, make some changes, and then submit a pull request. I'll review and merge as necessary.

Bug reports are also welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
