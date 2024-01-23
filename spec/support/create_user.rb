# frozen_string_literal: true

module CreateUser
  def create_user
    User::Repository.create_user(
      user_name: "test",
      email: "test@test.com",
      password: "test123"
    )
  end
end

RSpec.configure do |config|
  config.include CreateUser, type: :request
end
