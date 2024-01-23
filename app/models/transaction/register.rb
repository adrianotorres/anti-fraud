# frozen_string_literal: true

module Transaction
  class Register < ::Micro::Case
    attributes :external_id, :merchant_id, :user_id, :card_number, :date, :amount, :device_id, :has_cbk
    attribute :repository, {
      default: Repository,
      validates: {kind: {respond_to: :create_transaction}}
    }

    def call!
      calc_recommendation
        .then(:validate_attrs)
        .then(:register)
    end

    private def calc_recommendation
      @recommendation = if repository.consecutive(
        quantity: AntiFraud::Config.consecutive_quantity,
        start_date: date - AntiFraud::Config.consecutive_time.minutes,
        end_date: date + AntiFraud::Config.consecutive_time.minutes,
        criteria: {user_id:}
      ).exists?
                          Recommendation::DENY
                        else
                          Recommendation::APPROVE
                        end

      Success(:calculated_recommendation)
    end

    private def validate_attrs
      errors = {}
      errors[:external_id] = "can't be blank" if external_id.blank?
      errors[:merchant_id] = "can't be blank" if merchant_id.blank?
      errors[:user_id] = "can't be blank" if user_id.blank?
      errors[:card_number] = "can't be blank" if card_number.blank?
      errors[:amount] = "can't be blank" if amount.blank?
      errors[:date] = "can't be blank" if date.blank?
      errors[:recommendation] = "is invalid" unless Recommendation.valid?(@recommendation)

      return Failure :validation_errors, result: {errors:} if errors.keys.any?

      Success(:valid_values)
    end

    private def register
      transaction = repository.create_transaction(
        external_id:, merchant_id:, user_id:, card_number:,
        date:, amount:, device_id:, has_cbk:, recommendation: @recommendation
      )
      transaction ? Success(result: {transaction:}) : Failure(:transaction_not_registered)
    end

    private def date
      DateTime.parse @date
    end
  end
end
