# Uptrends RESTful API Client

[![Code Climate](http://img.shields.io/codeclimate/github/jasonwbarnett/uptrends-gem.svg?style=flat-square)](https://codeclimate.com/github/jasonwbarnett/uptrends-gem) [![Test Coverage](http://img.shields.io/codeclimate/coverage/github/jasonwbarnett/uptrends-gem.svg?style=flat-square)](https://codeclimate.com/github/jasonwbarnett/uptrends-gem) [![Build Status](http://img.shields.io/travis-ci/jasonwbarnett/uptrends-gem.svg?style=flat-square)](https://travis-ci.org/jasonwbarnett/uptrends-gem)

This is a ruby wrapper around the [Uptrends API][2]. Uptrends is a monitoring service that let's you monitor Web pages, Web services, Mail servers, Database servers, DNS, SSL certificates, FTP and more.

NOTE: This is a 3rd party gem and not an official product from Uptrends.

## Installation

Add this line to your application's Gemfile:

    gem 'uptrends'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uptrends

## Usage

    require 'uptrends'
    u = Uptrends::Client.new(username: 'my@email.com', password: 'MyP@sswo0rd')   #=> #<Uptrends::Client>

    probes = u.probes                     #=> [#<Uptrends::Probe>, #<Uptrends::Probe>, ...]
    p = probes.first                      #=> #<Uptrends::Probe>
    p.attributes                          #=> [:guid, :name, :url, :port, :check_frequency, :probe_type, :is_active, :generate_alert, :notes, :performance_limit1, :performance_limit2, :error_on_limit1, :error_on_limit2, :min_bytes, :error_on_min_bytes, :timeout, :tcp_connect_timeout, :match_pattern, :dns_lookup_mode, :user_agent, :user_name, :password, :is_competitor, :checkpoints, :http_method, :post_data]
    p.guid                                #=> "7ef43a1b255949f5a052444348971690"
    p.name                                #=> "My Probe's Name"

    probe_groups = u.probe_groups         #=> [#<Uptrends::ProbeGroup>, #<Uptrends::ProbeGroup>, ... ]
    pg = probe_groups.first               #=> #<Uptrends::ProbeGroup>
    pg.attributes                         #=> [:guid, :name, :is_all, :is_client_probe_group]
    pg.guid                               #=> "c8d6a0f704494c37823850f3d4fd4273"
    pg.name                               #=> "All probes"

    # Let's change the name of the probe:
    p.name = "My Probe's NEW name"        #=> "My Probe's NEW name"
    p.update!                             #=> nil

    # Let's add our probe to our probe group
    pg.add_probe(p)                       #=> [#<Uptrends::ProbeGroup>, #<Uptrends::Probe>]

## Contributing

1. Fork it ( https://github.com/jasonwbarnett/uptrends-gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


[1]: https://uptrends.com/
[2]: http://www.uptrends.com/en/support/api
