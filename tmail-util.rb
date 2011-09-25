require 'net/smtp'

class TMail::Mail
  attr_accessor :smtp_server

  def send_mail()
    self.write_back
    Net::SMTP.start(@smtp_server) do |smtp|
      smtp.sendmail(self.encoded, self.from, self.to)
    end
  end
end
