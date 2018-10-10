# frozen_string_literal: true

require "spec_helper"

module Spree
  describe Api::StoresController, type: :request do
    let(:user)       { create(:user)         }
    let(:admin_user) { create(:user, :admin) }

    let!(:store) do
      create(:store, name: "My Spree Store", url: "spreestore.example.com")
    end

    context "as an admin" do
      let!(:non_default_store) do
        create(:store,
          name: "Extra Store",
          url: "spreestore-5.example.com",
          default: false)
      end

      it "can list the available stores" do
        get spree.api_stores_path, headers: admin_user.create_new_auth_token
        expect(json_response["stores"]).to match_array([
          {
            "id" => store.id,
            "name" => "My Spree Store",
            "url" => "spreestore.example.com",
            "meta_description" => nil,
            "meta_keywords" => nil,
            "seo_title" => nil,
            "mail_from_address" => "spree@example.org",
            "default_currency" => nil,
            "code" => store.code,
            "default" => true,
            "available_locales" => ["en"]
          },
          {
            "id" => non_default_store.id,
            "name" => "Extra Store",
            "url" => "spreestore-5.example.com",
            "meta_description" => nil,
            "meta_keywords" => nil,
            "seo_title" => nil,
            "mail_from_address" => "spree@example.org",
            "default_currency" => nil,
            "code" => non_default_store.code,
            "default" => false,
            "available_locales" => ["en"]
          }
        ])
      end

      it "can get the store details" do
        get spree.api_store_path(store), headers: admin_user.create_new_auth_token
        expect(json_response).to eq(
          "id" => store.id,
          "name" => "My Spree Store",
          "url" => "spreestore.example.com",
          "meta_description" => nil,
          "meta_keywords" => nil,
          "seo_title" => nil,
          "mail_from_address" => "spree@example.org",
          "default_currency" => nil,
          "code" => store.code,
          "default" => true,
          "available_locales" => ["en"]
        )
      end

      it "can create a new store" do
        store_hash = {
          code: "spree123",
          name: "Hack0rz",
          url: "spree123.example.com",
          mail_from_address: "me@example.com"
        }
        post spree.api_stores_path, headers: admin_user.create_new_auth_token, params: { store: store_hash }
        expect(response.status).to eq(201)
      end

      it "can update an existing store" do
        store_hash = {
          url: "spree123.example.com",
          mail_from_address: "me@example.com"
        }
        put spree.api_store_path(store), headers: admin_user.create_new_auth_token, params: { store: store_hash }
        expect(response.status).to eq(200)
        expect(store.reload.url).to eql "spree123.example.com"
        expect(store.reload.mail_from_address).to eql "me@example.com"
      end

      context "deleting a store" do
        it "will fail if it's the default Store" do
          delete spree.api_store_path(store), headers: admin_user.create_new_auth_token
          expect(response.status).to eq(422)
          expect(json_response["errors"]["base"]).to eql(
            ["Cannot destroy the default Store."]
          )
        end

        it "will destroy the store" do
          delete spree.api_store_path(non_default_store), headers: admin_user.create_new_auth_token
          expect(response.status).to eq(204)
        end
      end
    end

    context "as an user" do
      it "cannot list all the stores" do
        get spree.api_stores_path, headers: user.create_new_auth_token
        expect(response.status).to eq(401)
      end

      it "cannot get the store details" do
        get spree.api_store_path(store), headers: user.create_new_auth_token
        expect(response.status).to eq(401)
      end

      it "cannot create a new store" do
        post spree.api_stores_path, headers: user.create_new_auth_token, params: { store: {} }
        expect(response.status).to eq(401)
      end

      it "cannot update an existing store" do
        put spree.api_store_path(store), headers: user.create_new_auth_token, params: { store: {} }
        expect(response.status).to eq(401)
      end
    end
  end
end
