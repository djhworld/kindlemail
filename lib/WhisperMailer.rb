require './lib/Mailer.rb'
require './lib/Message.rb'
require './lib/UtilityMethods.rb'
require './lib/constants.rb'
class WhisperMailer
  include Mailer
  attr_accessor :kindle_address
  def initialize(kindle_address)
    @kindle_address = kindle_address
  end

  def sync(file)
    raise ArgumentError, "The file you have specified does not exist #{SEE_HELP}" if file.nil? || !File.exist?(file)
    raise ArgumentError, "The file you have specified is not a valid type #{SEE_HELP}" if VALID_FILE_TYPES.include?(File.extname(file)) == false
    filepath = File.expand_path(file)
    puts "Preparing #{File.basename(file)} to be sent to #{@kindle_address}"
    msg = Message.new(@kindle_address, "a@b.c", filepath) 
    sendMessage(msg)
    puts "#{File.basename(file)} was successfully sent to #{@kindle_address}"
  end
end
