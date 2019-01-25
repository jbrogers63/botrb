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
      @running  = false
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
      @running = true
      start
    end

    def start
      Thread.new do
        while @running
          out = @socket.gets
          puts out
          if out =~ /^PING :(.*)$/
            say "PONG #{@name}"
            next
          end
        end
      end
    end

    def say(msg)
      @socket.puts msg
    end

    def join(channel)
      @channels << channel
      say "JOIN ##{channel}"
    end

    def part(channel)
      @channels -= [channel]
      say "PART ##{channel}"
    end

    def quit(msg = '')
      say "QUIT #{msg}"
    end

    def stop
      quit "#{@name} is quitting IRC..."
      @running = false
    end
  end
end
