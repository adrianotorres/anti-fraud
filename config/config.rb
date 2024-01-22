# frozen_string_literal: true

module AntiFraud
  Config = SuperConfig.new do
    mandatory :database_url, string
  end
end
