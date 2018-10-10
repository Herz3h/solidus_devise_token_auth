# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe Api::ClassificationsController, type: :request do
    let(:user)       { create(:user)         }
    let(:admin_user) { create(:user, :admin) }

    let(:taxon) do
      taxon = create(:taxon)

      3.times do
        product = create(:product)
        product.taxons << taxon
      end
      taxon
    end

    context "as a user" do
      it "cannot change the order of a product" do
        put spree.api_classifications_path,
          headers: user.create_new_auth_token,
          params: { taxon_id: taxon, product_id: taxon.products.first, position: 1 }

        expect(response.status).to eq(401)
      end
    end

    context "as an admin" do
      let(:last_product) { taxon.products.last }

      it "can change the order a product" do
        classification = taxon.classifications.find_by(product_id: last_product.id)
        expect(classification.position).to eq(3)
        put spree.api_classifications_path, headers: admin_user.create_new_auth_token, params: { taxon_id: taxon.id, product_id: last_product.id, position: 0 }
        expect(response.status).to eq(200)
        expect(classification.reload.position).to eq(1)
      end

      it "should touch the taxon" do
        taxon.update_attributes(updated_at: Time.current - 10.seconds)
        taxon_last_updated_at = taxon.updated_at
        put spree.api_classifications_path, headers: admin_user.create_new_auth_token, params: { taxon_id: taxon.id, product_id: last_product.id, position: 0 }
        taxon.reload
        expect(taxon_last_updated_at.to_i).to_not eq(taxon.updated_at.to_i)
      end
    end
  end
end
