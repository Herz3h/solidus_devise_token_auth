# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe Api::CreditCardsController, type: :request do
    describe '#index' do
      let!(:user)       { create(:user)         }
      let!(:admin_user) { create(:user, :admin) }

      let!(:card) { create(:credit_card, user_id: admin_user.id, gateway_customer_profile_id: "random") }

      it "the user id doesn't exist" do
        get spree.api_user_credit_cards_path(1000), headers: user.create_new_auth_token
        expect(response.status).to eq(404)
      end

      context "calling user is in admin role" do
        it "no credit cards exist for user" do
          get spree.api_user_credit_cards_path(user), headers: admin_user.create_new_auth_token

          expect(response.status).to eq(200)
          expect(json_response["pages"]).to eq(0)
        end

        it "can view all credit cards for user" do
          get spree.api_user_credit_cards_path(admin_user.id), headers: admin_user.create_new_auth_token

          expect(response.status).to eq(200)
          expect(json_response["pages"]).to eq(1)
          expect(json_response["current_page"]).to eq(1)
          expect(json_response["credit_cards"].length).to eq(1)
          expect(json_response["credit_cards"].first["id"]).to eq(card.id)
        end
      end

      context "calling user is not in admin role" do
        let!(:card) { create(:credit_card, user_id: user.id, gateway_customer_profile_id: "random") }

        it "can not view user" do
          get spree.api_user_credit_cards_path(admin_user.id), headers: user.create_new_auth_token

          expect(response.status).to eq(404)
        end

        it "can view own credit cards" do
          get spree.api_user_credit_cards_path(user.id), headers: user.create_new_auth_token

          expect(response.status).to eq(200)
          expect(json_response["pages"]).to eq(1)
          expect(json_response["current_page"]).to eq(1)
          expect(json_response["credit_cards"].length).to eq(1)
          expect(json_response["credit_cards"].first["id"]).to eq(card.id)
        end
      end
    end

    describe '#update' do
      let(:credit_card_user) { create(:user) }
      let(:credit_card)      { create(:credit_card, name: 'Joe Shmoe', user: credit_card_user) }

      context 'when the user is authorized' do
        it 'updates the credit card' do
          expect {
            put spree.api_credit_card_path(credit_card.to_param),
              headers: credit_card_user.create_new_auth_token,
              params: { credit_card: { name: 'Jordan Brough' } }
          }.to change {
            credit_card.reload.name
          }.from('Joe Shmoe').to('Jordan Brough')
        end
      end

      context 'when the user is not authorized' do
        let(:other_user) { create(:user) }

        it 'rejects the request' do
          put spree.api_credit_card_path(credit_card.to_param),
            headers: other_user.create_new_auth_token,
            params: { credit_card: { name: 'Jordan Brough' } }

          expect(response.status).to eq(401)
        end
      end
    end
  end
end
