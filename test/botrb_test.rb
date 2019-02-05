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
    @bot.say 'Hello, there!'
    assert @server.gets.chomp!.eql? 'Hello, there!'
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
end
