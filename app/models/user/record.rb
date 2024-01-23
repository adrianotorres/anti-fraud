# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = "users"

    has_secure_password

    validates :user_name, presence: true, uniqueness: true
    validates :email, presence: true
    validates :password, presence: true
  end
end
