require 'trollop'
require 'yaml'
require 'fileutils'
require 'KindleMailer.rb'
require 'constants.rb'
require 'KindleMailFileDatastore.rb'

# This contains all the code needed to run the CLI application
module KindleMail
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
      puts "Creating user email conf file"
      root = File.expand_path(File.dirname(__FILE__))
      root = File.expand_path("../conf_templates", root)
      FileUtils.cp(File.join(root, '/.email_conf'), EMAIL_CONF_FILE)
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

  class Application
    attr_reader :cmd_parser
    attr_reader :opts

    def initialize
      puts "#{VERSION_STRING}\n\n"
      @datastore = KindleMailFileDatastore.new
      @config_manager = KindleMail::Configuration.new
      @config_manager.configuration_setup
    end

    def run
      setup
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

      @opts = Trollop::options do
        version VERSION_STRING
        banner ban
        opt :kindle_address, "Overrides the default kindle address to send items to", :short => "-k", :type => :string
        opt :force, "Send the file regardless of whether you have sent it before", :short => "-f", :default => nil
        opt :show_history, "Show the history of files that have been sent using kindlemail", :short => "-s", :default => nil
        opt :clear_history, "Clear the history of files that have been sent using kindlemail", :short => "-d", :default => nil
        opt :show_info, "Show information about the way kindlemail is setup", :short => "-i", :default => nil
      end
    end

    def process
      begin
        if(@opts[:show_info_given])
          print_info
          exit
        end

        if(@opts[:show_history_given])
          @datastore.print_history
          exit
        end

        if(@opts[:clear_history_given])
          do_it = false
          if(!@opts[:force_given])      
             print "Are you sure you wish to clear the history of files you have sent using kindlemail? [y/n]> "
             response = gets.to_s.chomp
             if(response.empty? or response.downcase.eql?("y") or response.downcase.eql?("yes"))
               do_it = true
             end
          else
            do_it = true
          end

          if(do_it)
            print "Clearing file history"
            @datastore.clear_history
            puts "...done"
          end
          exit
        end

        if ARGV.empty?
          raise ArgumentError, "Please specify a file to send (or use the -h option to see help)" 
        end

        mailer = KindleMailer.new(@config_manager.get_email_credentials)

        kindle_address = ""
        if(!@opts[:kindle_address_given])
          # no -k flag specified, see if a configuration file has been set
          if(File.exist?(USER_CONF_FILE))
            config = @config_manager.get_user_credentials
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
          if(@datastore.file_exists?(kindle_address, File.basename(file_to_send))) 
            raise ArgumentError, "This file has already been sent to #{kindle_address}. Use the --force (-f) option if you want to resend it"
          end
        end

        send_result = mailer.send(kindle_address, file_to_send)
        @datastore.add_entry(kindle_address,File.basename(file_to_send)) if send_result

      rescue ArgumentError => message
        puts "#{message}"
      rescue => message
        puts "Error occured: - \n#{message}"
      end
    end
    def print_info
      puts "kindlemail was born out of my own laziness. To put things bluntly" 
      puts "I'm too lazy to pick up my beloved Kindle, get a usb cable, plug"
      puts "it into my computer, drag and drop books and documents to it,"
      puts "unplug the usb cable. Too ardous and involves getting up."
      puts
      puts "So I wrote this, it's simple, a bit rubbish, probably doesn't work" 
      puts "properly but it's useful when I just want to fire off a .mobi book" 
      puts "to my Kindle and forget about it until later."
      puts
      puts "Amazon have made a great service with the Personal Document Service," 
      puts "although it's worth reminding users of the 3G Kindle that they will" 
      puts "be charged for using this service"
      puts 
      puts "If you hate this application, supress your hatred and tell me what" 
      puts "you hate about it so I can change it"
      puts 
      puts "Version:                #{APP_VERSION}"
      puts "Homepage:               #{HOMEPAGE}" 
      puts "Author:                 #{AUTHOR}"
      puts 

      begin
        config = @config_manager.get_user_credentials
      rescue
        puts "You do not appear to have a valid user credentials file!"
      else
        puts "Default kindle address: #{config[:kindle_addr]}\n\n"
      end
    end
  end
end
