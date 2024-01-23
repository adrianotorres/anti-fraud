# frozen_string_literal: true

module Transaction
  module Repository
    extend self

    def create_transaction(external_id:, merchant_id:, user_id:, card_number:, date:, amount:, device_id:, has_cbk:)
      Record.create(external_id:, merchant_id:, user_id:, card_number:, date:, amount:, device_id:,
                    has_cbk: has_cbk || false)
    end
  end
end
