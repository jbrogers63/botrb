# frozen_string_literal: false

require 'socket'
require_relative 'event'

module Botrb
  # This is the class that does most of the legwork
  # of the bot.
  class Bot
    attr_accessor :name, :host, :port, :socket, :channels, :handlers

    # initialize expects a hash
    def initialize(config = {})
      @handlers = []
      @channels = []
      @running  = false
      if block_given?
        yield self
      else
        @name     = config[:name] || ''
        @host     = config[:host] || 'irc.freenode.com'
        @port     = config[:port] || 6667
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
          event = Botrb::Event.parse_event @socket.gets
          puts event
          dispatch event
        end
      end
    end

    def run
      connect
      on_event nil, /^PING.*/ do
        @bot.write "PONG #{@name}"
      end
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

    def on_event(type, regex = //, &block)
      handler = Botrb::Handler.new(type, regex, &block)
      @handlers.push handler
    end

    def dispatch(event)
      matched_handlers = @handlers.select do |h|
        h.match event
      end

      matched_handlers.map do |h|
        Thread.new { h.block.call }
      end
    end
  end
end
