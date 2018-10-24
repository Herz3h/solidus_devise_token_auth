# frozen_string_literal: true

require 'cancan'

module Spree
  module TestingSupport
    module AuthorizationHelpers
      module CustomAbility
        def build_ability(&block)
          block ||= proc{ |_u| can :manage, :all }
          Class.new do
            include CanCan::Ability
            define_method(:initialize, block)
          end
        end
      end

      module Controller
        include CustomAbility

        def stub_authorization!(&block)
          ability_class = build_ability(&block)
          before do
            allow(controller).to receive(:current_ability).and_return(ability_class.new(nil))
          end
        end
      end

      module Request
        include CustomAbility

        def stub_api_authentication!
          before do
            allow_any_instance_of(Spree::Api::BaseController)
              .to receive("current_api_#{Spree.user_class.to_s.underscore.gsub('/', '_')}")
              .and_return(create(:user))
          end
        end

        def stub_ability_authorization!
          ability = build_ability

          after(:all) do
            Spree::Ability.remove_ability(ability)
          end

          before(:all) do
            Spree::Ability.register_ability(ability)
          end
        end

        def stub_authorization!
          stub_ability_authorization!
          stub_api_authentication!
        end

        def custom_authorization!(&block)
          ability = build_ability(&block)
          after(:all) do
            Spree::Ability.remove_ability(ability)
          end
          before(:all) do
            Spree::Ability.register_ability(ability)
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.extend Spree::TestingSupport::AuthorizationHelpers::Controller, type: :controller
  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :feature
  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :request
end
