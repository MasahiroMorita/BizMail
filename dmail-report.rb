
require 'rubygems'
require 'date'
require 'date-util'
require 'tmail'
require 'tmail-util'
require 'biz_mail_processor.rb'

$MYDOMAIN = 'dmail.pgw.jp'
#$BIZMAIL_DIR = '/Users/hiropipi/Documents/workspace/BizMail/'
$BIZMAIL_DIR = '/home/hiropipi/bizmail/'

$CONFIG_YAML = $BIZMAIL_DIR + 'config.yaml'
$DBFILE = $BIZMAIL_DIR + 'dbfile.sqlite3'

mail_msg = STDIN.read
rec_mail = TMail::Mail.parse(mail_msg)

processor = BizMailProcessor.new
processor.parse_mail(rec_mail.from, rec_mail.to,
                     rec_mail.date, NKF.nkf("--utf8", rec_mail.subject), NKF.nkf("--utf8", rec_mail.body))

rep_mail = processor.generate_report_mail
exit unless rep_mail
rep_mail.smtp_server = 'localhost'
rep_mail.write_back
rep_mail.send_mail

comb_rep_mail = processor.generate_combined_report_mail
exit unless comb_rep_mail
comb_rep_mail.smtp_server = 'localhost'
comb_rep_mail.write_back
comb_rep_mail.send_mail
