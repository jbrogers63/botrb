require 'socket'

module Botrb
  # This is the class that does most of the legwork
  # of the bot.
  class Bot
    attr_accessor :name, :host, :port, :channels, :socket

    # initialize expects a hash
    def initialize(config = {})
      @name     = config[:name] || ''
      @host     = config[:host] || 'irc.freenode.com'
      @port     = config[:port] || 6667
      @channels = config[:channels] || []
    end

    def connect
      @socket = TCPSocket.open @host, @port
      say "NICK #{@name}"
      say "USER #{@name} 0 * #{@name}"
      @channels.each do |channel|
        say "JOIN ##{channel}"
      end
    end

    def run
      connect
      while (out = @socket.gets)
        if out =~ /^PING :(.*)$/
          say "PONG #{$~[1]}"
          next
        end
        puts out
      end
    end

    def say(msg)
      @socket.puts msg
    end
  end
end
