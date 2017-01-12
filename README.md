# Murga

A simple JRuby web server framework built on top of Ratpack. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'murga'
```

Install the gem:

    $ bundle install

## Usage

Create a `server.rb` file:

```ruby
# Setup the server
server = Murga::Server.new host: ENV['HOST'], port: ENV['PORT'], log_requests: true
# start the server and run until INT/TERM signal
server.start_and_keep_running
```

And run your new server:

    $ jruby server.rb

## Development

After checking out the repo, run `bin/murga_setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/murga_console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/murga. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

