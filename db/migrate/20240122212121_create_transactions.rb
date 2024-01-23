# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.integer :external_id, null: false
      t.integer :merchant_id, null: false
      t.integer :user_id, null: false
      t.string :card_number, null: false
      t.datetime :date, null: false
      t.string :amount, null: false
      t.integer :device_id
      t.boolean :has_cbk, default: false, null: false

      t.timestamps
    end
  end
end