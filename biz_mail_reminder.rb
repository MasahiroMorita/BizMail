require 'rubygems'
require 'yaml'
require 'date'
require 'date-util'
require 'tmail'
require 'tmail-util'
require 'erb'

class BizMailReminder
  def initialize(user)
    config = YAML.load_file($CONFIG_YAML)
    @report_user = user
    @current_config = config[user]
    @person = ''
    @kpi = ''
    erb = ERB.new(File.read($BIZMAIL_DIR + @current_config['remind']))
    erb.def_method(BizMailReminder, :_gen_remind, @current_config['remind'])
  end
  
  def remind_to_person(&block)
    return if @current_config['type'] != 'aggregated_persons'
    
    @current_config['remind_to'].each do |k, v|
      tmail = TMail::Mail.new
      tmail.content_type = 'text/plain'
      tmail.charset = 'iso-2022-jp'
      tmail.date = Time.now
      kpi_id = ''
      @current_config['kpi'].each do |_k, _v|
        kpi_id = _k
        @kpi = _v
      end

      tmail.from = [@report_user + '+' + [date.to_YYYYMMDD, kpi_id, k].join('-') + '@' + $MYDOMAIN]
      tmail.reply_to = tmail.from

      @person = @current_config['person'][k]
      tmail.to = v
      reminder = _gen_remind.split("\n")
      subject = reminder[0]
      reminder.shift
      body = reminder.join("\n")
      tmail.subject = '=?ISO-2022-JP?B?' + NKF.nkf('--jis', subject).split(//, 1).pack('m').chomp + '?='
      tmail.body = NKF.nkf('--jis', body)
      
      block.call(tmail)
    end
  end
  
  def remind_for_kpi(&block)
    return if @current_config['type'] == 'aggregated_persons'

    @person = nil
    tmail = TMail::Mail.new
    tmail.content_type = 'text/plain'
    tmail.charset = 'iso-2022-jp'
    tmail.date = Time.now

    @current_config['kpi'].each do |k, v|
      @kpi = v
      tmail.from = [@report_user + '+' + [date.to_YYYYMMDD, k, ''].join('-') + '@' + $MYDOMAIN]
      tmail.reply_to = tmail.from
    
      tmail.to = @current_config['remind_to']
      reminder = _gen_remind.split("\n")
      subject = reminder[0]
      reminder.shift
      body = reminder.join("\n")
      tmail.subject = '=?ISO-2022-JP?B?' + NKF.nkf('--jis', subject).split(//, 1).pack('m').chomp + '?='
      tmail.body = NKF.nkf('--jis', body)
    
      block.call(tmail)
    end
  end
  
  def date
    offset = 0
    offset = 1 if @current_config['remind_date'] == 'yesterday'
    return Date.today - offset
  end
  
  def person
    return @person
  end
  
  def kpi
    return @kpi
  end
end

if __FILE__ == $0 then
require 'rubygems'

$CONFIG_YAML = "/Users/hiropipi/Documents/workspace/BizMail/config.yaml"
$MYDOMAIN = 'dmail.pgw.jp'

my_reminder = BizMailReminder.new('user01')

my_reminder.remind_to_person do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  puts NKF.nkf('--utf8', tmail.encoded)
  #tmail.send_mail
end

my_reminder.remind_for_kpi do |tmail|
  tmail.smtp_server = 'localhost'
  tmail.write_back
  puts NKF.nkf('--utf8', tmail.encoded)
  #tmail.send_mail
end
end