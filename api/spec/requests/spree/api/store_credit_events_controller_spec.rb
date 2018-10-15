# frozen_string_literal: true

require 'spec_helper'

describe Spree::Api::StoreCreditEventsController, type: :request do
  let(:user) { create(:user) }

  describe "GET mine" do
    context "no current api user" do
      subject { get spree.mine_api_store_credit_events_path(format: :json) }
      before  { subject }

      it "returns a 401" do
        expect(response.status).to eq 401
      end
    end

    context "the current api user is authenticated" do
      subject { get spree.mine_api_store_credit_events_path(format: :json), headers: user.create_new_auth_token }

      context "the user doesn't have store credit" do
        before { subject }

        it "should set the events variable to empty list" do
          expect(json_response["store_credit_events"]).to eq []
        end

        it "returns a 200" do
          expect(response.status).to eq 200
        end
      end

      context "the user has store credit" do
        let!(:store_credit) { create(:store_credit, user: user) }

        before { subject }

        it "should contain the store credit allocation event" do
          expect(json_response["store_credit_events"].size).to eq 1
          expect(json_response["store_credit_events"][0]).to include(
            "display_amount" => "$150.00",
            "display_user_total_amount" => "$150.00",
            "display_action" => "Added"
          )
        end

        it "returns a 200" do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
