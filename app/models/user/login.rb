# frozen_string_literal: true

module User
  class Login < ::Micro::Case
    attributes :email, :password
    attribute :repository, {
      default: Repository,
      validates: {kind: {respond_to: :valid_user?}}
    }

    def call!
      validate_attrs
        .then(:validate_user)
        .then(:generate_token)
    end

    private def validate_attrs
      errors = {}
      errors[:email] = "can't be blank" if email.blank?
      errors[:password] = "can't be blank" if password.blank?

      return Failure :validation_errors, result: {errors:} if errors.keys.any?

      Success :valid_values
    end

    private def validate_user
      @user = repository.find_by(criteria: {email:})

      return Failure :unauthorized unless @user
      return Failure :unauthorized unless @user.authenticate(password)

      Success :valid_user
    end

    private def generate_token
      token = JwtToken.encode(payload: {sub: @user.id})
      token ? Success(result: {token:}) : Failure(:error_token)
    end
  end
end
