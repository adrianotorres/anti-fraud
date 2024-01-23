# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deny transactions by amount on period", type: :request do
  describe "POST /transactions" do
    it "denies if transaction is outside the period's limit" do
      user = create_user

      [90, 120].each do |variant|
        post "/api/v1/transactions", headers: authenticated_header(user:), params: {
          transaction: {
            transaction_id: variant,
            merchant_id: 2,
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: variant.minutes.ago.strftime("%FT%T%:z"),
            transaction_amount: "304.02"
          }
        }
      end

      post "/api/v1/transactions", headers: authenticated_header(user:), params: {
        transaction: {
          transaction_id: 30,
          merchant_id: 2,
          user_id: 3,
          card_number: "9999********9999",
          transaction_date: 80.minutes.ago.strftime("%FT%T%:z"),
          transaction_amount: "1904.02"
        }
      }

      expect(response).to match_json_schema("transaction_response")
      expect(response.parsed_body["recommendation"].to_sym).to eq(Transaction::Recommendation::DENY)
    end
  end
end
