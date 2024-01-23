# frozen_string_literal: true

module AuthenticatedHeader
  def authenticated_header(user: nil)
    user ||= create_user

    token = User::JwtToken.encode(payload: {sub: user.id})
    {Authorization: "Bearer #{token}"}
  end
end

RSpec.configure do |config|
  config.include AuthenticatedHeader, type: :request
end
