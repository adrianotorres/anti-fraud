# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :transactions, action: :create, controller: :transactions
      post "/auth/login", action: :login, controller: :auth
    end
  end
end
