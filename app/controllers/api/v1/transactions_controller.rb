# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :validate_create_params, only: [:create]

      def create
        ::Transaction::Register
          .call(
            external_id: transaction_params[:transaction_id],
            date: transaction_params[:transaction_date],
            amount: transaction_params[:transaction_amount],
            **transaction_params
          )
          .on_success do |result|
            render json: {
              transaction_id: result.data[:transaction].external_id,
              recommendation: result.data[:transaction].recommendation
            }, status: :created
          end
          .on_failure(:validation_errors) do |result|
            render_error message: "Unprocessable entity", detail: result[:errors], status: :unprocessable_entity
          end
      end

      private def validate_create_params
        validation_result = JSON::Validator.fully_validate(schema, {transaction: transaction_params}.to_json)
        return unless validation_result.any?

        render_error message: "Invalid transaction structure", detail: validation_result, status: :unprocessable_entity
      end

      private def schema
        @schema ||= begin
          schema_file = Rails.root.join("lib/json_schemas/transaction.json")
          {
            type: "object",
            required: ["transaction"],
            properties: {
              transaction: {"$ref": "file://#{schema_file}"}
            }
          }
        end
      end

      private def transaction_params
        @transaction_params ||= params.require(:transaction).permit(
          :transaction_id, :merchant_id, :user_id,
          :card_number, :transaction_date, :transaction_amount,
          :device_id, :has_cbk
        )
      end
    end
  end
end
