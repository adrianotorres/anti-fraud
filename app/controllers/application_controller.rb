# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user

  def render_error(message:, detail: "", status: :internal_server_error, code: nil)
    render json: {
      error: {
        code: code || Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
        message:,
        detail:,
        timestamp: Time.zone.now
      }
    }, status:
  end

  private def authenticate_user
    header = request.headers["Authorization"]
    header = header.split.last if header

    decoded = User::JwtToken.decode(header)
    @current_user = User::Repository.find(user_id: decoded[:sub])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => error
    render_error message: error.message, status: :unauthorized
  end
end
