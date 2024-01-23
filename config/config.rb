# frozen_string_literal: true

module AntiFraud
  Config = SuperConfig.new do
    mandatory :database_url, string
    optional :consecutive_quantity, int, 2
    optional :consecutive_time, int, 30
    optional :period_average_time, int, 60
    optional :period_average_limit, int, 1000
  end
end
