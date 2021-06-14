# frozen_string_literal: false

require 'botrb/event'

module Botrb
  # Class to handle input from the IRC server
  class Handler
    attr_reader :block

    # rubocop:disable Style/OptionalArguments
    def initialize(type = nil, regex, &block)
      @type = type
      @regex = regex
      @block = block
    end
    # rubocop:enable Style/OptionalArguments

    def match(event)
      if !@type.nil?
        (event.send @type).match @regex
      else
        event.to_s.match @regex
      end
    end
  end
end
