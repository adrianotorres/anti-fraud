# frozen_string_literal: true

module Transaction
  module Repository
    extend self

    def create_transaction(
      external_id:, merchant_id:, user_id:, card_number:,
      date:, amount:, device_id:, has_cbk:, recommendation:
    )
      Record.create(
        external_id:, merchant_id:, user_id:, card_number:,
        date:, amount:, device_id:, recommendation:, has_cbk: has_cbk || false
      )
    end

    def consecutive(quantity:, start_date:, end_date:, criteria:)
      Record
        .select(criteria.keys)
        .where(criteria)
        .where("date BETWEEN ? AND ?", start_date, end_date)
        .group(criteria.keys)
        .having("COUNT(*) >= ?", quantity)
    end

    def period_average(start_date:, end_date:, criteria:)
      Record
        .where(criteria)
        .where("date BETWEEN ? AND ?", start_date, end_date)
        .average(:amount)
    end

    def chargeback_for?(user_id:)
      Record.exists?(has_cbk: true, user_id:)
    end
  end
end
