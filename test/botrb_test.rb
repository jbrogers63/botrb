# frozen_string_literal: false

require 'test_helper'

class BotrbTest < Minitest::Test
  attr_accessor :server, :bot

  def setup
    config = {
      name: 'Botrb'
    }
    @bot = Botrb::Bot.new config
    @server, @bot.socket = IO.pipe
  end

  def test_that_it_has_a_version_number
    refute_nil ::Botrb::VERSION
  end

  def test_bot_setup
    assert @bot.name.eql? 'Botrb'
  end

  def test_say_method
    @bot.say 'test-irc-bot', 'Hello, there!'
    assert @server.gets.chomp!.eql? 'PRIVMSG #test-irc-bot :Hello, there!'
  end

  def test_reply_to_method
    @bot.reply_to 'test-user', 'Hello, there!'
    assert @server.gets.chomp!.eql? 'PRIVMSG test-user :Hello, there!'
  end

  def test_join_method
    @bot.join 'test-channel'
    assert @server.gets.chomp!.eql? 'JOIN #test-channel'
    assert @bot.channels.eql? ['test-channel']
  end

  def test_part_method
    @bot.part 'test-channel'
    assert @server.gets.chomp!.eql? 'PART #test-channel'
    assert @bot.channels.empty?
  end

  def test_quit_method
    @bot.quit 'Bye!'
    assert @server.gets.chomp!.eql? 'QUIT Bye!'

    @bot.quit
    assert @server.gets.chomp!.eql? 'QUIT'
  end

  def test_nick_method
    @bot.nick @bot.name
    assert @server.gets.chomp!.eql? "NICK #{@bot.name}"
  end

  def test_user_method
    @bot.user @bot.name
    assert @server.gets.chomp!.eql? "USER #{@bot.name} 0 * #{@bot.name}"
  end

  def test_on_event_handling
    @bot.on_event nil, /^PING.*/ do
      @bot.write "PONG #{@bot.name}"
    end
    assert @bot.handlers.count.eql? 1
    @bot.dispatch Botrb::Event.parse_event 'PING :irc.host.com'
    @server.gets.chomp!.eql? "PONG #{@bot.name}"
  end
end
