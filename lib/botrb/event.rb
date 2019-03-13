module Botrb
  # Add some basic handling for 'events', which are full
  # IRC messages to be parsed. This should help with implementing
  # later features.
  class Event
    attr_accessor :user, :hostname, :type, :channel, :message
    EVENT_FORMAT = /(.*)!~(.*) (.*) (.*) :(.*)/.freeze

    def initialize(user, hostname, type, channel, message)
      @user     = user
      @hostname = hostname
      @type     = type
      @channel  = channel
      @message  = message
    end

    def self.parse_event(msg)
      msg.match(EVENT_FORMAT) { |e| Event.new(*e.captures) } ||
        Event.new(nil, nil, nil, nil, msg)
    end

    def to_s
      if @user.nil?
        @message
      else
        "#{@user}!~#{hostname} #{type} #{channel} :#{message}"
      end
    end
  end
end
