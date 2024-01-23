# frozen_string_literal: true

module User
  module Repository
    extend self

    def create_user(user_name:, email:, password:, name: nil)
      Record.create(user_name:, email:, password:, name:)
    end

    def find(user_id:)
      Record.find(user_id)
    end

    def find_by(criteria:)
      Record.find_by(criteria)
    end
  end
end
