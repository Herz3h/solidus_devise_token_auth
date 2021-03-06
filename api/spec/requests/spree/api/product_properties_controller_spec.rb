# frozen_string_literal: true

require 'spec_helper'
require 'shared_examples/protect_product_actions'

module Spree
  describe Spree::Api::ProductPropertiesController, type: :request do
    let(:user)       { create(:user)         }
    let(:admin_user) { create(:user, :admin) }

    let!(:product) { create(:product) }
    let!(:property_1) { product.product_properties.create(property_name: "My Property 1", value: "my value 1", position: 0) }
    let!(:property_2) { product.product_properties.create(property_name: "My Property 2", value: "my value 2", position: 1) }

    let(:attributes) { [:id, :product_id, :property_id, :value, :property_name] }
    let(:resource_scoping) { { product_id: product.to_param } }

    context "if product is deleted" do
      before do
        product.update_column(:deleted_at, 1.day.ago)
      end

      it "can not see a list of product properties" do
        get spree.api_product_product_properties_path(product), headers: user.create_new_auth_token
        expect(response.status).to eq(404)
      end
    end

    it "can see a list of all product properties" do
      get spree.api_product_product_properties_path(product), headers: user.create_new_auth_token
      expect(json_response["product_properties"].count).to eq 2
      expect(json_response["product_properties"].first).to have_attributes(attributes)
    end

    it "can control the page size through a parameter" do
      get spree.api_product_product_properties_path(product), headers: user.create_new_auth_token, params: { per_page: 1 }
      expect(json_response['product_properties'].count).to eq(1)
      expect(json_response['current_page']).to eq(1)
      expect(json_response['pages']).to eq(2)
    end

    it 'can query the results through a parameter' do
      Spree::ProductProperty.last.update_attribute(:value, 'loose')
      property = Spree::ProductProperty.last
      get spree.api_product_product_properties_path(product), headers: user.create_new_auth_token, params: { q: { value_cont: 'loose' } }
      expect(json_response['count']).to eq(1)
      expect(json_response['product_properties'].first['value']).to eq property.value
    end

    it "can see a single product_property" do
      get spree.api_product_product_property_path(product, property_1.property_name), headers: user.create_new_auth_token
      expect(json_response).to have_attributes(attributes)
    end

    it "can learn how to create a new product property" do
      get spree.new_api_product_product_property_path(product), headers: user.create_new_auth_token
      expect(json_response["attributes"]).to eq(attributes.map(&:to_s))
      expect(json_response["required_attributes"]).to be_empty
    end

    it "cannot create a new product property if not an admin" do
      post spree.api_product_product_properties_path(product), headers: user.create_new_auth_token, params: { product_property: { property_name: "My Property 3" } }
      assert_unauthorized!
    end

    it "cannot update a product property" do
      put spree.api_product_product_property_path(product, property_1.property_name), headers: user.create_new_auth_token, params: { product_property: { value: "my value 456" } }
      assert_unauthorized!
    end

    it "cannot delete a product property" do
      delete spree.api_product_product_property_path(product, property_1.property_name), headers: user.create_new_auth_token
      assert_unauthorized!
      expect { property_1.reload }.not_to raise_error
    end

    context "as an admin" do
      it "can create a new product property" do
        expect do
          post spree.api_product_product_properties_path(product), headers: admin_user.create_new_auth_token, params: { product_property: { property_name: "My Property 3", value: "my value 3" } }
        end.to change(product.product_properties, :count).by(1)
        expect(json_response).to have_attributes(attributes)
        expect(response.status).to eq(201)
      end

      it "can update a product property" do
        put spree.api_product_product_property_path(product, property_1.property_name), headers: admin_user.create_new_auth_token, params: { product_property: { value: "my value 456" } }
        expect(response.status).to eq(200)
      end

      it "can delete a product property" do
        delete spree.api_product_product_property_path(product, property_1.property_name), headers: admin_user.create_new_auth_token
        expect(response.status).to eq(204)
        expect { property_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with product identified by id" do
      it "can see a list of all product properties" do
        get spree.api_product_product_properties_path(product), headers: admin_user.create_new_auth_token
        expect(json_response["product_properties"].count).to eq 2
        expect(json_response["product_properties"].first).to have_attributes(attributes)
      end

      it "can see a single product_property by id" do
        get spree.api_product_product_property_path(product, property_1.id), headers: admin_user.create_new_auth_token
        expect(json_response).to have_attributes(attributes)
      end
    end
  end
end
