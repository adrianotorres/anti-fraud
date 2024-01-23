# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transactions", type: :request do
  describe "POST /transactions" do
    let(:user) { create_user }
    let(:headers) { authenticated_header(user:) }

    context "with valid parameters" do
      it "returns created status" do
        post "/api/v1/transactions", headers:, params: {
          transaction: {
            transaction_id: 1,
            merchant_id: 2,
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: 5.days.ago.strftime("%FT%T%:z"),
            transaction_amount: "302.02"
          }
        }

        expect(response).to have_http_status(:created)
      end

      it "saves transaction on database" do
        expect do
          post "/api/v1/transactions", headers:, params: {
            transaction: {
              transaction_id: 1,
              merchant_id: 2,
              user_id: 3,
              card_number: "9999********9999",
              transaction_date: 5.days.ago.strftime("%FT%T%:z"),
              transaction_amount: "302.02"
            }
          }
        end.to change(Transaction::Record, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "returns error response" do
        post "/api/v1/transactions", headers:, params: {transaction: {transaction_id: 123}}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_json_schema("error")
      end

      it "returns blank field error message" do
        post "/api/v1/transactions", headers:, params: {
          transaction: {
            transaction_id: 1,
            merchant_id: "",
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: 5.days.ago.strftime("%FT%T%:z"),
            transaction_amount: "302.02"
          }
        }

        json_response = response.parsed_body
        expect(json_response["error"].present?).to be_truthy
        expect(json_response["error"]["code"]).to eq(422)
        expect(json_response["error"]["detail"]["merchant_id"]).to eq("can't be blank")
      end
    end
  end
end
