# frozen_string_literal: true

require 'spree/testing_support/sequences'
require 'spree/testing_support/factories/role_factory'
require 'spree/testing_support/factories/address_factory'

FactoryBot.define do
  factory :user, class: Spree::UserClassHandle.new do
    email    { generate(:email) }
    password { 'lubieplacki' }

    trait :admin do
      spree_roles { [Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')] }
    end

    trait :with_addresses do |_u|
      bill_address
      ship_address
    end
  end
end
