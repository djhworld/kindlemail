require 'test/unit'
require 'KindleMailer.rb'
class TestKindleMailer < Test::Unit::TestCase

  def setup
    @mailer = KindleMailer.new({})
  end

  def test_constructor_with_nil_credentials
    assert_raise(ArgumentError) { @mailer = KindleMailer.new(nil) }
  end

  def test_send_with_nil_kindle_address
    assert_raise(ArgumentError) { @mailer.send(nil, "file") }
  end

  def test_validate_kindle_address_with_nil_addr
    assert_not_nil(@mailer.validate_kindle_address(nil))
  end

  def test_validate_kindle_address_with_non_kindle_addr
    assert_not_nil(false, @mailer.validate_kindle_address("kindlemail@gmail.com"))
  end
end
