[![Build Status](https://img.shields.io/travis/gurix/helena/master.svg?style=flat)](https://travis-ci.org/gurix/helena)
[![Code Climate](https://img.shields.io/codeclimate/github/gurix/helena.svg?style=flat)](https://codeclimate.com/github/gurix/helena)
[![Dependency Status](https://img.shields.io/gemnasium/gurix/helena.svg?style=flat)](https://gemnasium.com/gurix/helena)
[![Dependency Status](https://img.shields.io/gem/v/helena.svg?style=flat)](https://rubygems.org/gems/helena)
# Helena
Helena is an online survey/test framework designed for agile survey/test development, longitudinal studies and instant feedback.

![swiss made software](https://raw.githubusercontent.com/gurix/helena/master/app/assets/images/helena/swissmadesoftware.png "swiss made software")

Demo: http://helena-demo.herokuapp.com (https://github.com/gurix/helena-demo)
## Requirements
* Rails (4.1 or higher)
* Mongoid (4.0.0 or higher)
* MongoDB (2.4.10 or higher)

## Installation
Add this line to your application's Gemfile:

    gem 'helena'

And then execute:

    $ bundle install

## Usage

Add this line to your routes will and you will be good to go!

    mount Helena::Engine => '/helena'

Since Version 1.0 the admin interface is no longer a part of the gem and was extracted to http://github.com/gurix/helena-admin.

## TODOS
* Support more question types, i.e Dates, Numeric inputs with validation, emails, ...
* Customize question type views for each survey

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contact

[info@markusgraf.ch](mailto: info@markusgraf.ch)

Or at [#HelenaFramework](irc://chat.freenode.net/HelenaFramework) on freenode.net

## Support

If you like helena and want to support the development, I would appreciate a donation:

[![Donate](https://www.paypalobjects.com/en_US/CH/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=info%40markusgraf%2ech&lc=CH&item_name=Helena&currency_code=CHF&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

## License

Helena is an online survey/test framework designed for agile
survey/test development, longitudinal studies and instant feedback.
Copyright (C) 2014  Markus Graf <info@markusgraf.ch>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
