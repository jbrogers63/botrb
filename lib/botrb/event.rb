module Botrb
  # Add some basic handling for 'events', which are full
  # IRC messages to be parsed. This should help with implementing
  # later features.
  module Event
    EVENT_FORMAT = /(.*)!~(.*) (.*) (.*) :(.*)/.freeze
    EventStruct = Struct.new :user, :hostname, :type, :channel, :message

    def self.parse_event(msg)
      msg.match(EVENT_FORMAT) { |e| EventStruct.new(*e.captures) }
    end
  end
end
