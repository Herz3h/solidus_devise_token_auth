# frozen_string_literal: true

require_relative '../core/lib/spree/core/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_backend_devise_token_auth'
  s.version     = Spree.solidus_version
  s.summary     = 'Admin interface for the Solidus e-commerce framework (devise_token_auth version)'
  s.description = s.summary

  s.author      = 'Michał Siwek (skycocker)'
  s.email       = 'mike21@aol.pl'
  s.homepage    = 'https://github.com/skycocker/solidus/tree/master/backend'
  s.license     = 'BSD-3-Clause'

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version = '>= 2.2.2'
  s.required_rubygems_version = '>= 1.8.23'

  s.add_dependency 'solidus_api_devise_token_auth',  s.version
  s.add_dependency 'solidus_core_devise_token_auth', s.version

  s.add_dependency 'coffee-rails'
  s.add_dependency 'font-awesome-rails', '~> 4.0'
  s.add_dependency 'jbuilder', '~> 2.6'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'kaminari', '~> 1.1'
  s.add_dependency 'sassc-rails'

  s.add_dependency 'autoprefixer-rails'
  s.add_dependency 'handlebars_assets', '~> 0.23'

  s.add_development_dependency 'pry'
end
