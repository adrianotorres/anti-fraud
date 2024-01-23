# frozen_string_literal: true

module Transaction
  class Record < ApplicationRecord
    self.table_name = "transactions"

    validates :external_id, :merchant_id, :user_id, :card_number, :date, :amount, presence: true
  end
end
