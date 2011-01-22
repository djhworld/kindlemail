require 'yaml'
require 'constants.rb'
require 'fileutils'
class Configuration
  def load_yaml(file)
    YAML.load_file(file).inject({}){|memo,(k,v)| memo[k.to_sym] = v.to_s; memo}
  end

  # Create the user framework needed to run the application
  def configuration_setup
    dirname = File.expand_path(USER_DIR)
    if !File.exists?(dirname)
      Dir.mkdir(dirname) 
      create_storage_dir
      create_staging_dir
      create_user_conf_file
      create_user_email_conf_file
    else     
      create_user_conf_file if !File.exists?(USER_CONF_FILE)
      create_storage_dir if !File.exists?(File.expand_path(STORAGE_DIR))
      create_staging_dir if !File.exists?(File.expand_path(STAGING_DIR))
      create_user_email_conf_file if !File.exists?(EMAIL_CONF_FILE)
    end
  end

  def create_storage_dir
    Dir.mkdir(File.expand_path(STORAGE_DIR))
  end

  def create_staging_dir
    Dir.mkdir(File.expand_path(STAGING_DIR))
  end

  def create_user_conf_file
    root = File.expand_path(File.dirname(__FILE__))
    root = File.expand_path("../conf_templates", root)
    FileUtils.cp(File.join(root, '/.kindlemail'), USER_CONF_FILE)
  end

  def create_user_email_conf_file
    root = File.expand_path(File.dirname(__FILE__))
    root = File.expand_path("../conf_templates", root)
    FileUtils.cp(File.join(root, '/.email_conf'), EMAIL_CONF_FILE)
  end

  def set_default_kindle_address(address)
    raise ArgumentError, "Error: No email address entered" if address.nil? or address.empty?

    print "Setting up kindle credentials..."
    File.open(USER_CONF_FILE,"w") do |file|
      file.puts "kindle_addr: #{address}"
    end
    puts "Complete!"
  end

  def set_email_credentials(token, token_secret, email)
    raise ArgumentError, "Error: Please provide a valid OAUTH token" if token.nil? or token.empty?
    raise ArgumentError, "Error, Please provide a valid OAUTH token secret"  if token_secret.nil? or token.empty?
    raise ArgumentError, "Error: Please provide a valid gmail address" if email.nil? or email.empty?
    print "Setting up email credentials..."
    File.open(EMAIL_CONF_FILE, "w") do |file|
      file.puts "smtp_oauth_token: #{token}"
      file.puts "smtp_oauth_token_secret: #{token_secret}"
      file.puts "email #{email}"
    end
    puts "Complete!"
  end


  def get_email_credentials
    raise ArgumentError, "Cannot find email credentials file #{EMAIL_CONF_FILE}." if !File.exists?(EMAIL_CONF_FILE)
    begin
      load_yaml(EMAIL_CONF_FILE)
    rescue
      raise StandardError, "Error parsing #{EMAIL_CONF_FILE}"
    end
  end

  def get_user_credentials
    error_msg =  "The configuration file #{USER_CONF_FILE} was found but appears to be invalid/incomplete.\nThe most likely reason for this is the fact that you need to set a default kindle address to send items to.\nYou must edit the file and follow the instructions in the comments before trying again. Alternatively use the -k flag to specify a kindle address to send the item to" 

    raise ArgumentError, "Cannot find user credentials file #{USER_CONF_FILE}." if !File.exists?(USER_CONF_FILE)
    begin
      config = load_yaml(USER_CONF_FILE)
    rescue
      raise StandardError, error_msg
    end

    raise StandardError, error_msg if config.key?(:kindle_addr) == false || config[:kindle_addr].nil?
    return config
  end
end

