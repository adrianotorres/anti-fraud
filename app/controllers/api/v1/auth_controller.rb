# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      before_action :validate_login_params, only: :login
      before_action :authenticate_user, except: :login

      def login
        ::User::Login.call(
          email: login_params[:email],
          password: login_params[:password]
        )
                     .on_success do |result|
          render json: {token: result.data[:token]}, status: :created
        end
        .on_failure(:unauthorized) { render_error message: "Unauthorized", status: :unauthorized }
      end

      private def validate_login_params
        validation_result = JSON::Validator.fully_validate(schema, {user: login_params}.to_json)
        return unless validation_result.any?

        render_error message: "Invalid transaction structure", detail: validation_result, status: :unprocessable_entity
      end

      private def schema
        @schema ||= begin
          schema_file = Rails.root.join("lib/json_schemas/login.json")
          {
            type: "object",
            required: ["user"],
            properties: {
              user: {"$ref": "file://#{schema_file}"}
            }
          }
        end
      end

      private def login_params
        @login_params ||= params.require(:user).permit(:email, :password)
      end
    end
  end
end
