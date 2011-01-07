require 'fileutils'
require 'yaml'
require './lib/GmailMailer.rb'
require './lib/KindleMailFileDatastore.rb'
require './lib/constants.rb'
class KindleMailer
  attr_accessor :kindle_address
  def initialize
    configuration_setup
  end

  def send(kindle_address, file, force_send)
    @kindle_address = kindle_address
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
    raise ArgumentError, "Cannot find email credentials file #{EMAIL_CONF_FILE}." if !File.exists?(EMAIL_CONF_FILE)
    config = YAML.load_file(EMAIL_CONF_FILE).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    mailer = GmailMailer::Mailer.new(config)
    mailer.sendMessage(GmailMailer::Message.new(@kindle_address, "a@b.c", filepath))

    #record that message was sent
    datastore.add_entry(@kindle_address,File.basename(file))
    puts "#{File.basename(file)} was successfully sent to #{@kindle_address}"
  end

  def configuration_setup
    dirname = File.expand_path(USER_DIR)
    if !File.exists?(dirname)
      Dir.mkdir(dirname) 
      create_storage_dir
      create_user_conf_file
    else     
      create_user_conf_file if !File.exists?(USER_CONF_FILE)
      create_storage_dir if !File.exists?(File.expand_path(STORAGE_DIR))
    end
  end

  def create_storage_dir
    Dir.mkdir(File.expand_path(STORAGE_DIR))
  end
  def create_user_conf_file
      FileUtils.cp('conf_templates/.kindlemail', USER_CONF_FILE)
  end
end 
