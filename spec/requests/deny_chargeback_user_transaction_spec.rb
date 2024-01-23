# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deny transaction of chargeback users", type: :request do
  describe "POST /transactions" do
    it "denies if user has chargebak" do
      user = create_user

      [true, false].each do |has_cbk|
        post "/api/v1/transactions", headers: authenticated_header(user:), params: {
          transaction: {
            transaction_id: 1,
            merchant_id: 2,
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: 10.minutes.ago.strftime("%FT%T%:z"),
            transaction_amount: "304.02",
            has_cbk:
          }
        }
      end

      expect(response).to match_json_schema("transaction_response")
      expect(response.parsed_body["recommendation"].to_sym).to eq(Transaction::Recommendation::DENY)
    end
  end
end
