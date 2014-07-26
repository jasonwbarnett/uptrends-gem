# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uptrends/version'

Gem::Specification.new do |spec|
  spec.name          = "uptrends"
  spec.version       = Uptrends::VERSION
  spec.authors       = ["Jason Barnett"]
  spec.email         = ["J@sonBarnett.com"]
  spec.summary       = %q{Ruby wrapper around the Uptrends API, http://www.uptrends.com/}
  spec.description   = %q{Uptrends is a monitoring service that let's you monitor  Web pages, Web services, Mail servers, Database servers, DNS, SSL certificates, FTP anod more.}
  spec.homepage      = "https://github.com/jasonwbarnett/uptrends-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
