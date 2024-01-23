# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :transactions, action: :create, controller: :transactions
    end
  end
end
