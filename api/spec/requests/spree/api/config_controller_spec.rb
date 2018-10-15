# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe Api::ConfigController, type: :request do
    let(:user) { create(:user) }

    let!(:default_country) { create :country, iso: "US" }

    it "returns Spree::Money settings" do
      get '/api/config/money', headers: user.create_new_auth_token
      expect(response).to be_successful
      expect(json_response["symbol"]).to eq("$")
    end

    it "returns some configuration settings" do
      get '/api/config', headers: user.create_new_auth_token
      expect(response).to be_successful
      expect(json_response["default_country_iso"]).to eq("US")
      expect(json_response["default_country_id"]).to eq(default_country.id)
    end
  end
end
