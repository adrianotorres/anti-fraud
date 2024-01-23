# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.integer :external_id, null: false
      t.integer :merchant_id, null: false
      t.integer :user_id, null: false
      t.string :card_number, null: false
      t.datetime :date, null: false
      t.integer :amount, null: false
      t.integer :device_id
      t.boolean :has_cbk, default: false, null: false

      t.timestamps
    end

    add_index :transactions, :user_id
    add_index :transactions, %i[user_id date]
    add_index :transactions, %i[user_id has_cbk]
  end
end
