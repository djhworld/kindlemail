def sendMessage(message)
  mail = Mail.new do
    from message.from
    to message.to
    subject message.subject
    body message.body
    if(message.attachment != nil)
      add_file {:filename => message.filename, :content => File.read(message.filepath)}
    end
  end
  mail.deliver!
end

