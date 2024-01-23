# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth login", type: :request do
  describe "POST /auth/login" do
    let(:user) { create_user }

    context "with valid parameters" do
      it "returns token if is authorized" do
        post "/api/v1/auth/login", params: {
          user: {
            email: user.email,
            password: "test123"
          }
        }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["token"]).not_to be_nil
      end

      it "returns unauthorized error message if is not authorized" do
        post "/api/v1/auth/login", params: {
          user: {
            email: user.email,
            password: "test1234"
          }
        }

        json_response = response.parsed_body
        expect(json_response["error"].present?).to be_truthy
        expect(json_response["error"]["code"]).to eq(401)
      end
    end

    context "with invalid parameters" do
      it "returns error response" do
        post "/api/v1/auth/login", params: {user: {email: 123}}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to match_json_schema("error")
      end
    end
  end
end
