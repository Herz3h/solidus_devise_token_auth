# frozen_string_literal: true

require_relative '../core/lib/spree/core/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_sample_devise_token_auth'
  s.version     = Spree.solidus_version
  s.summary     = 'Sample data (including images) for use with Solidus (devise_token_auth revised version)'
  s.description = s.summary

  s.author      = 'Michał Siwek (skycocker)'
  s.email       = 'mike21@aol.pl'
  s.homepage    = 'https://github.com/skycocker/solidus/tree/master/sample'
  s.license     = 'BSD-3-Clause'

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version = '>= 2.2.2'
  s.required_rubygems_version = '>= 1.8.23'

  s.add_dependency 'solidus_core_devise_token_auth', s.version
end
