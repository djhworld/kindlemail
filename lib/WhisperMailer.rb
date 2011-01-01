require './lib/Mailer.rb'
require './lib/Message.rb'
require './lib/UtilityMethods.rb'
class WhisperMailer
  include Mailer
  attr_accessor :from, :kindle_address
  def initialize(from, kindle_address)
    @from, @kindle_address = from, kindle_address
  end

  def sync(file)
    raise ArgumentError if file.nil? || !File.exist?(file)
    puts "Preparing #{file} to be sent to #{@kindle_address}"
    msg = Message.new(@kindle_address, @from, file) 
    sendMessage(msg)
    puts "Item #{file} was successfully sent to #{@kindle_address}"
  end
end
