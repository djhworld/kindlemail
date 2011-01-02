require 'trollop'
require './lib/UtilityMethods.rb'
require './lib/WhisperMailer.rb'
require './lib/constants.rb'
begin
  ban = ""
  ban << "whisper will send items to your kindle in the simplest possible manner"
  ban << "\n\nValid filetypes: -"
  VALID_FILE_TYPES.each { |key,val| ban << "\n  #{key} - #{val}" }
  ban << "\n\nUsage: -"
  ban << "\n  whisper [options] <filename>"
  ban << "\n\nExample usage: -"
  ban << "\n whisper my_book.mobi"
  ban << "\n\nWhere [options] are: -"

  p = Trollop::Parser.new do
    version VERSION
    banner ban
    opt :kindle_address, "Overrides the default kindle address to send items to", :short => "-k", :type => :string
    opt :force, "Send the file regardless of whether you have sent it before", :short => "-f", :default => nil
  end

  opts = Trollop::with_standard_exception_handling p do
    o = p.parse ARGV 
    raise Trollop::HelpNeeded if ARGV.empty? # show help screen
    o
  end

  kindle_address = ""

  if(!opts[:kindle_address_given])
    # no -k flag specified, see if a configuration file has been set
    if(File.exist?(USER_CONF_FILE))
      config = YAML.load_file(USER_CONF_FILE).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      raise ArgumentError, "A configuration file was found in ~/.whisper but appears to be invalid" if config.key?(:kindle_addr) == false || config[:kindle_addr].nil?
      kindle_address = config[:kindle_addr]
    else
      raise ArgumentError, "No address has been specified to send the item to.\nEither add an address in ~/.whisper or use the -kindle_address (-k) option"
    end
  else
    #User has specified the -k flag 
    kindle_address = opts[:kindle_address]
  end

  mailer = WhisperMailer.new(kindle_address)
  VERSION.length.times { print "-" }
  puts "\n#{VERSION}"
  VERSION.length.times { print "-" }
  puts

  if(opts[:force_given])
    mailer.sync(ARGV[0],true)
  else
    mailer.sync(ARGV[0],false)
  end

rescue ArgumentError => message
  puts "#{message}"
end
