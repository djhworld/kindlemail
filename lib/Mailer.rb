require 'mail'
require 'gmail_xoauth'
require './lib/UtilityMethods.rb'
require './lib/constants.rb'
module Mailer
  include UtilityMethods
  def sendMessage(message)
    mail = Mail.new do
      from message.from
      to message.to
      subject message.subject
      body message.body
      if(message.attachment != nil)
        add_file message.attachment
      end
    end
    sendSMTP(mail)
  end

  # Use gmail_xoauth to send email
  def sendSMTP(mail)
    config = loadConfig(EMAIL_CONF_FILE)
    
    smtp = Net::SMTP.new(config[:smtp_server], config[:smtp_port])
    smtp.enable_starttls_auto
    secret = {
      :consumer_key => config[:smtp_consumer_key],
      :consumer_secret => config[:smtp_consumer_secret],
      :token => config[:smtp_oauth_token],
      :token_secret => config[:smtp_oauth_token_secret]
    }
    smtp.start(config[:host], config[:email], secret, :xoauth) do |session|
      print "Sending message..."
      session.send_message(mail.encoded, mail.from_addrs.first, mail.destinations)
      puts ".sent!"
    end
  end
end
