# highcharts_exporting

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/highcharts_exporting`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'highcharts_exporting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install highcharts_exporting

## Usage

Add `highcharts_controller.rb` and add routes `post 'highcharts/export'`.

```ruby
class HighchartsController < ApplicationController
  include HighchartsExporting::Exporter

end
```

Config url '/highcharts/export' for highcharts exporting.


## Contributing

1. Fork it ( https://github.com/bastengao/highcharts_exporting/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
