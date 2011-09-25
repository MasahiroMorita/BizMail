#!/usr/bin/ruby

$LOAD_PATH.push(File.dirname($0))

require 'rubygems'
require 'date'
require 'date-util'
require 'tmail'
require 'tmail-util'
require 'biz_mail_processor.rb'

$MYDOMAIN = 'dmail.pgw.jp'
$BIZMAIL_DIR = '/Users/hiropipi/Documents/workspace/BizMail/'
#$BIZMAIL_DIR = '/home/hiropipi/bizmail/'

$CONFIG_YAML = $BIZMAIL_DIR + 'config.yaml'
$DBFILE = $BIZMAIL_DIR + 'dbfile.sqlite3'

mail_msg = STDIN.read
rec_mail = TMail::Mail.parse(mail_msg)

processor = BizMailProcessor.new
processor.parse_mail(rec_mail.from, rec_mail.to,
                     rec_mail.date, NKF.nkf("--utf8", rec_mail.subject), NKF.nkf("--utf8", rec_mail.body))

processor.generate_report_mail do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  puts NKF.nkf('--utf8', tmail.encoded)
  #tmail.send_mail
end

processor.generate_combined_report_mail do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  puts NKF.nkf('--utf8', tmail.encoded)
  #tmail.send_mail
end
