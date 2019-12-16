# AmazonStaticSite

Upload static HTML/CSS/JS to the Amazon S3 and host HTTPS site for free using Cloudflare.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'amazon_static_site'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon_static_site

## Usage

`/usr/local/rvm/rubies/ruby-2.6.5/bin/ruby ./bin/amazon_static_site ./sample/config/site.yml ./sample`
`/usr/local/rvm/rubies/ruby-2.6.5/bin/ruby ./bin/amazon_static_site serve ./sample`

## Local

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/amazon_static_site.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
