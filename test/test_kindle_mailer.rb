require 'test/unit'
require 'fileutils'
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
    assert_raise(ArgumentError) { @mailer.validate_kindle_address(nil) }
  end

  def test_validate_kindle_address_with_non_kindle_addr
    assert_raise(ArgumentError) { @mailer.validate_kindle_address("kindlemail@gmail.com") }
  end

  def test_validate_file_path_with_non_existent_file
    assert_raise(ArgumentError) { @mailer.validate_file_path("k") }
  end

  def test_validate_file_path_with_existent_file
    file = File.expand_path("test/file1.txt")
    FileUtils.touch(file)
    assert_nothing_raised { @mailer.validate_file_path(file) }
    FileUtils.rm(file)
  end

  def test_validate_file_path_with_erroneous_file_type
    file = File.expand_path("test/file1.xyz")
    FileUtils.touch(file)
    assert_raise(ArgumentError) { @mailer.validate_file_path(file) }
    FileUtils.rm(file)
  end
end
