# frozen_string_literal: true

require_relative 'core/lib/spree/core/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_devise_token_auth'
  s.version     = Spree.solidus_version
  s.summary     = 'Full-stack e-commerce framework for Ruby on Rails (devise_token_auth revised version)'
  s.description = 'Solidus is an open source e-commerce framework for Ruby on Rails.'

  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version     = '>= 2.2.2'
  s.required_rubygems_version = '>= 1.8.23'

  s.author       = 'Michał Siwek (skycocker)'
  s.email        = 'mike21@aol.pl'
  s.homepage     = 'https://github.com/skycocker/solidus'
  s.license      = 'BSD-3-Clause'

  s.add_dependency 'solidus_api_devise_token_auth',      s.version
  s.add_dependency 'solidus_backend_devise_token_auth',  s.version
  s.add_dependency 'solidus_core_devise_token_auth',     s.version
  s.add_dependency 'solidus_frontend_devise_token_auth', s.version
  s.add_dependency 'solidus_sample_devise_token_auth',   s.version
end
