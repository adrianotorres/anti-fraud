# frozen_string_literal: true

module User
  module JwtToken
    extend self

    SECRET_KEY = Rails.application.secret_key_base

    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      ActiveSupport::HashWithIndifferentAccess.new(decoded)
    end

    def encode(payload:, exp: 7.days.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  end
end
