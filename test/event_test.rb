require 'test_helper'

class EventTest < Minitest::Test
  attr_accessor :msg

  def setup
    @msg = 'test!~test@localhost PRIVMSG #test-channel :hello'
  end

  def test_event_parse
    event = Botrb::Event.parse_event(@msg)
    event.user.eql? 'test'
    event.hostname.eql? 'localhost'
    event.type.eql? 'PRIVMSG'
    event.channel.eql? '#test-channel'
    event.message.eql? 'hello'
  end
end
