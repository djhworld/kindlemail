require 'gmail-mailer'
require 'constants.rb'
class KindleMailer
  attr_accessor :kindle_address
  attr_accessor :email_credentials
  def initialize(email_credentials)
    @email_credentials = email_credentials
  end

  def send(kindle_address, file)
    @kindle_address = kindle_address
    filepath = File.expand_path(file)
    raise ArgumentError, "The file you have specified does not exist #{SEE_HELP}" if file.nil? || !File.exist?(filepath)
    raise ArgumentError, "The file you have specified is not a valid type #{SEE_HELP}" if VALID_FILE_TYPES.include?(File.extname(file)) == false

    puts "Preparing #{File.basename(filepath)} to be sent to #{@kindle_address}"

    begin
      message = GmailMailer::Message.new(@kindle_address)
      message.add_attachment(filepath)
      
      mailer = GmailMailer::Mailer.new(@email_credentials)
      mailer.send(message)
    rescue ArgumentError => error_msg
      raise 
    end

    puts "#{File.basename(filepath)} was successfully sent to #{@kindle_address}"
    return true
  end
end 
