# frozen_string_literal: true

require 'spec_helper'

describe "Rabl Cache", type: :request, caching: true do
  let(:user) { create(:user, :admin) }

  before do
    create(:variant)
    expect(Spree::Product.count).to eq(1)
  end

  it "doesn't create a cache key collision for models with different rabl templates" do
    get "/api/variants", headers: user.create_new_auth_token
    expect(response.status).to eq(200)

    # Make sure we get a non master variant
    variant_a = JSON.parse(response.body)['variants'].find do |v|
      !v['is_master']
    end

    expect(variant_a['is_master']).to be false
    expect(variant_a['stock_items']).not_to be_nil

    get "/api/products/#{Spree::Product.first.id}", headers: user.create_new_auth_token
    expect(response.status).to eq(200)
    variant_b = JSON.parse(response.body)['variants'].last
    expect(variant_b['is_master']).to be false

    expect(variant_a['id']).to eq(variant_b['id'])
    expect(variant_b['stock_items']).to be_nil
  end
end
