#!/usr/bin/ruby

$LOAD_PATH.push(File.dirname($0))

require 'rubygems'
require 'biz_mail_reminder.rb'

$MYDOMAIN = 'dmail.pgw.jp'
#$BIZMAIL_DIR = '/Users/hiropipi/Documents/workspace/BizMail/'
$BIZMAIL_DIR = '/home/hiropipi/bizmail/BizMail/'

$CONFIG_YAML = $BIZMAIL_DIR + 'config.yaml'
$DBFILE = $BIZMAIL_DIR + 'dbfile.sqlite3'

reminder = BizMailReminder.new(ARGV[0])

reminder.remind_to_person do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  #puts NKF.nkf('--utf8', tmail.encoded)
  tmail.send_mail
end

reminder.remind_for_kpi do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  #puts NKF.nkf('--utf8', tmail.encoded)
  tmail.send_mail
end
