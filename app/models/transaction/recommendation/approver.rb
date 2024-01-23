# frozen_string_literal: true

module Transaction
  module Recommendation
    module Approver
      extend self

      def call(user_id:, date:, amount:)
        return ::Transaction::Recommendation::DENY if chargeback?(user_id:)
        return ::Transaction::Recommendation::DENY if consecutive_transaction?(date:, user_id:)
        return ::Transaction::Recommendation::DENY if amount_greater_period_average?(date:, user_id:, amount:)

        ::Transaction::Recommendation::APPROVE
      end

      def chargeback?(user_id:)
        ::Transaction::Repository.chargeback_for?(user_id:)
      end

      def consecutive_transaction?(date:, user_id:)
        ::Transaction::Repository.consecutive(
          quantity: AntiFraud::Config.consecutive_quantity,
          start_date: date - AntiFraud::Config.consecutive_time.minutes,
          end_date: date + AntiFraud::Config.consecutive_time.minutes,
          criteria: {user_id:}
        ).exists?
      end

      def amount_greater_period_average?(date:, user_id:, amount:)
        average = ::Transaction::Repository.period_average(
          start_date: date - AntiFraud::Config.period_average_time.minutes,
          end_date: date + AntiFraud::Config.period_average_time.minutes,
          criteria: {user_id:}
        )

        average && (amount - average) > AntiFraud::Config.period_average_limit
      end
    end
  end
end
