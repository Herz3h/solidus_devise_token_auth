# frozen_string_literal: true

require_relative '../core/lib/spree/core/version.rb'

Gem::Specification.new do |gem|
  gem.author        = 'Michał Siwek (skycocker)'
  gem.email         = 'mike21@aol.pl'
  gem.homepage      = 'https://github.com/skycocker/solidus/tree/master/api'
  gem.license       = 'BSD-3-Clause'

  gem.summary       = 'REST API for the Solidus e-commerce framework (devise_token_auth revised version)'
  gem.description   = gem.summary

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'solidus_api_devise_token_auth'
  gem.require_paths = ["lib"]
  gem.version       = Spree.solidus_version

  gem.required_ruby_version = '>= 2.2.2'
  gem.required_rubygems_version = '>= 1.8.23'

  gem.add_dependency 'jbuilder', '~> 2.6'
  gem.add_dependency 'kaminari-activerecord', '~> 1.1'
  gem.add_dependency 'responders'
  gem.add_dependency 'solidus_core_devise_token_auth', gem.version

  # it's simply the latest rubygems published version
  # at the time of writing it,
  # feel free to update
  gem.add_dependency 'devise_token_auth', '~> 1.0.0rc2'

  gem.add_development_dependency 'pry'
end
