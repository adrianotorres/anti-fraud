# frozen_string_literal: true

class AddRecommendationToTransactions < ActiveRecord::Migration[7.1]
  def change
    create_enum :recommendation, %w[deny approve]

    change_table :transactions do |t|
      t.enum :recommendation, enum_type: "recommendation", null: false
    end
  end
end
