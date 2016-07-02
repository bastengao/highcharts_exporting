# highcharts_exporting

[![Build Status](https://travis-ci.org/bastengao/highcharts_exporting.svg?branch=master)](https://travis-ci.org/bastengao/highcharts_exporting)
[![Code Climate](https://codeclimate.com/github/bastengao/highcharts_exporting/badges/gpa.svg)](https://codeclimate.com/github/bastengao/highcharts_exporting)
[![Test Coverage](https://codeclimate.com/github/bastengao/highcharts_exporting/badges/coverage.svg)](https://codeclimate.com/github/bastengao/highcharts_exporting)
[![Gem Version](https://badge.fury.io/rb/highcharts_exporting.svg)](http://badge.fury.io/rb/highcharts_exporting)

Highcharts server exporting for Rails.

## Installation

_**NOTE**_: [Phatomjs](https://github.com/colszowka/phantomjs-gem) is required, please install it before.

Add this line to your application's Gemfile:

```ruby
gem 'highcharts_exporting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install highcharts_exporting

## Usage

Add `highcharts_controller.rb`.

```ruby
class HighchartsController < ApplicationController
  include HighchartsExporting::Exporter

end
```

Add route in `routes.rb`.
```ruby
post 'highcharts/export'
```

Config url `/highcharts/export` in highcharts [options](http://api.highcharts.com/highcharts#exporting).

```javascript
$('#container').highcharts({
  ...
  exporting: {
    url: '/highcharts/export'
    ...
  }
});
```

## Hot it works

Default Hightcharts privides two implementations of languages(PHP and Java) as export server, for more [details](http://www.highcharts.com/docs/export-module/setting-up-the-server).

However Hightcharts also privides a [image convert script](https://github.com/highcharts/highcharts-export-server/tree/master/phantomjs) executing in Phantomjs environment for exporting. I just use [Phantomjs gem](https://github.com/colszowka/phantomjs-gem) to invoke `highcharts-convert.js` with params sent by client. More [details](http://www.highcharts.com/docs/export-module/render-charts-serverside).

## References

* http://www.highcharts.com/docs/export-module/export-module-overview
* https://github.com/highslide-software/highcharts.com/tree/master/exporting-server/phantomjs


## Contributing

1. Fork it ( https://github.com/bastengao/highcharts_exporting/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
