# Backtrail
[![Code Climate](https://codeclimate.com/github/dferrazm/backtrail/badges/gpa.svg)](https://codeclimate.com/github/dferrazm/backtrail)
[![Build Status](https://travis-ci.org/dferrazm/backtrail.svg?branch=master)](https://travis-ci.org/dferrazm/backtrail)

Keep a trail of request paths for your Rails application

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'backtrail'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install backtrail
```

## Usage

In your `ApplicationController` add:

```ruby
class ApplicationController < ActionController::Base
  include Backtrail::BaseController
end
```

With that, all your `get` and `non xhr` request paths will start to be keep tracked on a trail stack. To generate links that go back on the trail of paths, use the view helper `<%= backtrail %>`. This will generate a link like:

```html
<a class="backtrail" href="/[path]?trail=back">Back</a>
```

The `[path]` is the top path from the trail stack. It can be returned through the `previous_path` method (that is also a view helper) included with `Backtrail::BaseController`.

## Contributing

Questions or problems? Please post them on the [issue tracker](https://github.com/dferrazm/backtrail/issues).

You can contribute by doing the following:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

To test the application run `bundle install` and then `rake test`.

## License

MIT License.
