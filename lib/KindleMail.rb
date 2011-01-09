require 'trollop'
require 'yaml'
require 'FileUtils'
require 'KindleMailer.rb'
require 'constants.rb'
require 'KindleMailFileDatastore.rb'

# This contains all the code needed to run the CLI application
module KindleMail
  class Configuration
    # Create the user framework needed to run the application
    def configuration_setup
      dirname = File.expand_path(USER_DIR)
      if !File.exists?(dirname)
        Dir.mkdir(dirname) 
        create_storage_dir
        create_user_conf_file
        create_user_email_conf_file
      else     
        create_user_conf_file if !File.exists?(USER_CONF_FILE)
        create_storage_dir if !File.exists?(File.expand_path(STORAGE_DIR))
        create_user_email_conf_file if !File.exists?(EMAIL_CONF_FILE)
      end
    end

    def create_storage_dir
      Dir.mkdir(File.expand_path(STORAGE_DIR))
    end

    def create_user_conf_file
      FileUtils.cp('conf_templates/.kindlemail', USER_CONF_FILE)
    end

    def create_user_email_conf_file
      FileUtils.cp('conf_templates/.email_conf', EMAIL_CONF_FILE)
    end

    def get_email_credentials
      raise ArgumentError, "Cannot find email credentials file #{EMAIL_CONF_FILE}." if !File.exists?(EMAIL_CONF_FILE)
      YAML.load_file(EMAIL_CONF_FILE).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    end
  end

  class Application
    attr_reader :cmd_parser
    attr_reader :opts
    def run
      setup
      parse
      process
    end

    def setup
      ban = ""
      ban << "kindlemail will send items to your kindle in the simplest possible manner"
      ban << "\n\nValid filetypes: -"
      VALID_FILE_TYPES.each { |key,val| ban << "\n  #{key} - #{val}" }
      ban << "\n\nUsage: -"
      ban << "\n  kindlemail [options] <filename>"
      ban << "\n\nExample usage: -"
      ban << "\n kindlemail my_book.mobi"
      ban << "\n\nWhere [options] are: -"

      @cmd_parser = Trollop::Parser.new do
        version VERSION_STRING
        banner ban
        opt :kindle_address, "Overrides the default kindle address to send items to", :short => "-k", :type => :string
        opt :force, "Send the file regardless of whether you have sent it before", :short => "-f", :default => nil
        opt :show_history, "Show the history of files that have been sent using kindlemail", :short => "-s", :default => nil
        opt :clear_history, "Clear the history of files that have been sent using kindlemail", :short => "-d", :default => nil
      end
    end

    def parse
      @opts = Trollop::with_standard_exception_handling p do
        o = @cmd_parser.parse ARGV 
      end
    end


    def process
      begin
        puts "\n#{VERSION_STRING}\n\n"
        if ARGV.empty?
          raise ArgumentError, "Please specify a file to send (or use the -h option to see help)" 
        end
        config_manager = KindleMail::Configuration.new
        config_manager.configuration_setup

        mailer = KindleMailer.new(config_manager.get_email_credentials)
        datastore = KindleMailFileDatastore.new

        if(@opts[:show_history_given])
          datastore.print_history
          exit
        end

        if(@opts[:clear_history_given])
          print "Clearing file history"
          datastore.clear_history
          puts "...done"
          exit
        end

        kindle_address = ""

        if(!@opts[:kindle_address_given])
          # no -k flag specified, see if a configuration file has been set
          if(File.exist?(USER_CONF_FILE))
            config = YAML.load_file(USER_CONF_FILE).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
            raise ArgumentError, "The configuration file #{USER_CONF_FILE} was found but appears to be invalid/incomplete.\nThe most likely reason for this is the fact that you need to set a default kindle address to send items to.\nYou must edit the file and follow the instructions in the comments before trying again. Alternatively use the -k flag to specify a kindle address to send the item to" if config.key?(:kindle_addr) == false || config[:kindle_addr].nil?
            kindle_address = config[:kindle_addr]
          else
            raise ArgumentError, "No address has been specified to send the item to.\nEither add an address in #{USER_CONF_FILE} or use the -kindle_address (-k) option"
          end
        else
          #User has specified the -k flag 
          kindle_address = @opts[:kindle_address]
        end

        force_send = @opts[:force_given] ? true : false 
        file_to_send = ARGV[0]

        if(!force_send)
          if(datastore.file_exists?(kindle_address, File.basename(file_to_send))) 
            raise ArgumentError, "This file has already been sent to #{kindle_address}. Use the --force (-f) option if you want to resend it"
          end
        end

        send_result = mailer.send(kindle_address, file_to_send)
        datastore.add_entry(kindle_address,File.basename(file_to_send)) if send_result

      rescue ArgumentError => message
        puts "#{message}"
      end

    end
  end
end
