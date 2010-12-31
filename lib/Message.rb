class Message
  attr_reader :to, :from, :subject, :body, :attachment
  def initialize(to, from, subject, body, attachment)
    @to = to
    @from = from
    @subject = subject
    @body = body
    @attachment = attachment
  end
end
