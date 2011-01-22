require 'gmail-mailer'
require 'fileutils'
require 'digest/md5'
require 'constants.rb'
class KindleMailer
  attr_accessor :kindle_address
  attr_accessor :email_credentials
  def initialize(email_credentials)
    raise ArgumentError, "You must supply email credentials to use KindleMailer" if email_credentials.nil?
    @email_credentials = email_credentials
  end

  def send(kindle_address, file)
    begin
      validate_kindle_address(kindle_address)
      @kindle_address = kindle_address

      filepath = File.expand_path(file)
      validate_file_path(filepath)


      puts "Preparing #{File.basename(filepath)} to be sent to #{@kindle_address}"

      if(File.extname(filepath).eql?(".mobi"))
        filepath = stage_file(filepath)
      end

      message = GmailMailer::Message.new(@kindle_address)
      message.add_attachment(filepath)
      
      mailer = GmailMailer::Mailer.new(@email_credentials)
      mailer.send(message)
    rescue 
      raise 
    ensure
      if(!filepath.nil? and File.exist?(filepath))
         FileUtils.rm(filepath) if(File.extname(filepath).eql?(".mobi"))
      end
    end

    puts "#{File.basename(file)} was successfully sent to #{@kindle_address}"
    return true
  end
  
  def validate_file_path(filepath)
    raise ArgumentError, "The file you have specified does not exist #{SEE_HELP}" if filepath.nil? || !File.exist?(filepath)
    raise ArgumentError, "The file you have specified is not a valid type #{SEE_HELP}" if VALID_FILE_TYPES.include?(File.extname(filepath)) == false
    return true 
  end

  def validate_kindle_address(addr)
    raise ArgumentError, "You must supply an address to send this item to" if addr.nil?
    raise ArgumentError, "#{addr} does not appear to be a valid kindle address" if !addr.end_with?("@kindle.com")
    return true 
  end

  def stage_file(filepath)
    new_filename=create_filename(filepath)
    new_location = File.expand_path(STAGING_DIR + "/" + new_filename)
    FileUtils.cp(filepath, new_location)
    new_location
  end

  def create_filename(file)
    new_filename = Digest::MD5.file(file).to_s+"_"+rand(1000000).to_s+File.extname(file)
  end
end 
