# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe Api::CountriesController, type: :request do
    let(:user) { create(:user) }

    before do
      @state = create(:state)
      @country = @state.country
    end

    it "gets all countries" do
      get spree.api_countries_path, headers: user.create_new_auth_token
      expect(json_response['countries'].first['iso3']).to eq @country.iso3
    end

    context "with two countries" do
      before { @zambia = create(:country, name: "Zambia") }

      it "can view all countries" do
        get spree.api_countries_path, headers: user.create_new_auth_token
        expect(json_response['count']).to eq(2)
        expect(json_response['current_page']).to eq(1)
        expect(json_response['pages']).to eq(1)
      end

      it 'can query the results through a paramter' do
        get spree.api_countries_path, headers: user.create_new_auth_token, params: { q: { name_cont: 'zam' } }
        expect(json_response['count']).to eq(1)
        expect(json_response['countries'].first['name']).to eq @zambia.name
      end

      it 'can control the page size through a parameter' do
        get spree.api_countries_path, headers: user.create_new_auth_token, params: { per_page: 1 }
        expect(json_response['count']).to eq(1)
        expect(json_response['current_page']).to eq(1)
        expect(json_response['pages']).to eq(2)
      end
    end

    it "includes states" do
      get spree.api_country_path(@country.id), headers: user.create_new_auth_token
      states = json_response['states']
      expect(states.first['name']).to eq @state.name
    end
  end
end
