require 'test_helper'

class HandlerTest < Minitest::Test
  attr_accessor :handler, :event

  def setup
    @handler = Botrb::Handler.new(:message, /hello/) do
      'hello back!'
    end

    msg = 'test!~test@localhost PRIVMSG #test-channel :hello'
    @event = Botrb::Event.parse_event msg
  end

  def test_handler_match
    assert @handler.match @event
    assert @handler.block.call.eql? 'hello back!'
  end
end
