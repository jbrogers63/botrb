require 'socket'

module Botrb
  # This is the class that does most of the legwork
  # of the bot.
  class Bot
    attr_accessor :name, :host, :port, :socket, :channels

    # initialize expects a hash
    def initialize(config = {})
      if block_given?
        yield self
      else
        @name     = config[:name] || ''
        @host     = config[:host] || 'irc.freenode.com'
        @port     = config[:port] || 6667
        @channels = []
        @running  = false
      end
    end

    def connect
      @socket = TCPSocket.open @host, @port
      nick @name
      user @name
    end

    def start
      Thread.new do
        while @running
          out = @socket.gets
          puts out
          if out =~ /^PING :(.*)$/
            write "PONG #{@name}"
            next
          end
        end
      end
    end

    def run
      connect
      @running = true
      start
    end

    def stop
      quit "#{@name} is quitting IRC..."
      @running = false
    end

    def write(msg)
      @socket.puts msg
    end

    def say(channel, msg)
      write "PRIVMSG ##{channel} :#{msg}"
    end

    def reply_to(user, msg)
      write "PRIVMSG #{user} :#{msg}"
    end

    def join(channel)
      @channels += [channel]
      write "JOIN ##{channel}"
    end

    def part(channel)
      @channels -= [channel]
      write "PART ##{channel}"
    end

    def quit(msg = nil)
      write msg.nil? ? 'QUIT' : "QUIT #{msg}"
    end

    def nick(name)
      write "NICK #{name}"
    end

    # Command: USER
    # Parameters: <username> <hostname> <servername> <realname>
    # Use the @bot.name for username and realname and fudge
    # the hostname and server name
    def user(username)
      write "USER #{username} 0 * #{username}"
    end
  end
end
