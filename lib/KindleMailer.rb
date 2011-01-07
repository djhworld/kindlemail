require './lib/Mailer.rb'
require './lib/Message.rb'
require './lib/UtilityMethods.rb'
require './lib/KindleMailFileDatastore.rb'
require './lib/constants.rb'
class KindleMailer
  attr_accessor :kindle_address
  def initialize(kindle_address)
    @kindle_address = kindle_address
  end

  def sync(file, force_send)
    raise ArgumentError, "The file you have specified does not exist #{SEE_HELP}" if file.nil? || !File.exist?(file)
    raise ArgumentError, "The file you have specified is not a valid type #{SEE_HELP}" if VALID_FILE_TYPES.include?(File.extname(file)) == false

    datastore = KindleMailFileDatastore.new
    if(!force_send)
      if(datastore.file_exists?(@kindle_address, File.basename(file))) 
        raise ArgumentError, "This file has already been sent to #{@kindle_address}. Use the --force (-f) option if you want to resend it"
      end
    end

    filepath = File.expand_path(file)
    puts "Preparing #{File.basename(file)} to be sent to #{@kindle_address}"

    #send email
    Mailer.new.sendMessage(Message.new(@kindle_address, "a@b.c", filepath))

    #record that message was sent
    datastore.add_entry(@kindle_address,File.basename(file))
    puts "#{File.basename(file)} was successfully sent to #{@kindle_address}"
  end
end 
