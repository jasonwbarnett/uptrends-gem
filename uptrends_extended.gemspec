# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uptrends_extended/version'

Gem::Specification.new do |spec|
  spec.name          = 'uptrends_extended'
  spec.version       = UptrendsExtended::VERSION
  spec.authors       = ['Jason Barnett', 'René Schultz Madsen']
  spec.email         = %w(J@sonBarnett.com rm@microting.com)
  spec.summary       = %q{Ruby wrapper around the Uptrends API, http://www.uptrends.com/}
  spec.description   = %Q{This is a ruby wrapper around the Uptrends API. Uptrends is a monitoring service that let's you monitor Web pages, Web services, Mail servers, Database servers, DNS, SSL certificates, FTP and more.\n\nNOTE: This is a 3rd party gem and not an official product from Uptrends.}
  spec.homepage      = 'https://github.com/microting/uptrends-gem'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty',      '~> 0.13'
  spec.add_dependency 'activesupport', '~> 3.2'
end
