# frozen_string_literal: true

module Transaction
  module Recommendation
    APPROVE = :approve
    DENY = :deny
    ALL = [APPROVE, DENY].freeze

    def self.valid?(value)
      ALL.include?(value)
    end
  end
end
