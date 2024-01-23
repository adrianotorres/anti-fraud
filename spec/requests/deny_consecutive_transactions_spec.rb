# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deny consecutive transactions", type: :request do
  describe "POST /transactions" do
    it "denies if user is trying too many transactions in a row" do
      [28, 15, 3].each do |variant|
        post "/api/v1/transactions", params: {
          transaction: {
            transaction_id: variant,
            merchant_id: 2,
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: variant.minutes.ago.strftime("%FT%T%:z"),
            transaction_amount: "302.02"
          }
        }
      end

      expect(response).to match_json_schema("transaction_response")
      expect(response.parsed_body["recommendation"].to_sym).to eq(Transaction::Recommendation::DENY)
    end

    it "doesn't deny if transactions have an interval of 1h+" do
      [60, 90, 120].each do |variant|
        post "/api/v1/transactions", params: {
          transaction: {
            transaction_id: variant,
            merchant_id: 2,
            user_id: 3,
            card_number: "9999********9999",
            transaction_date: variant.minutes.ago.strftime("%FT%T%:z"),
            transaction_amount: "302.02"
          }
        }
      end

      expect(Transaction::Record.where(recommendation: Transaction::Recommendation::APPROVE).count).to eq(3)
    end
  end
end
