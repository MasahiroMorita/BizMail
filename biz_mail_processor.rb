require 'rubygems'
require 'yaml'
require 'date'
require 'tmail'
require 'biz_log.rb'
require 'biz_log_context.rb'
require 'biz_target_context.rb'
require 'singlekpi_report_generator.rb'
require 'aggregated_persons_report_generator.rb'
require 'biz_log_status.rb'

class BizMailProcessor
  def initialize
    @config = YAML.load_file($CONFIG_YAML)
    
    @report_from = nil
    @report_date = nil
    @bizmail_user = nil
    @bizmail_person = ''
    @bizmail_kpi = ''
  end
  
  def parse_mail(from, to, date, subject, body)
    @report_from = from
    
    to = [to] if to.kind_of?(String)
    to.each do |t|
      laddr = t.split(/@/)[0]
      dom = t.split(/@/)[1]
      if dom == $MYDOMAIN then
        (@report_user, param) = laddr.split(/[+]/)
        @current_config = @config[@report_user]
        (date, kpi, person) = param.split(/-/)
        @report_date = Date.new(date[0, 4].to_i, date[4, 2].to_i, date[6, 2].to_i)
        @bizmail_kpi = @current_config['kpi'][kpi] if kpi != "" && @current_config['kpi']
        @bizmail_person = @current_config['person'][person] if person != "" && @current_config['person']
      end
    end
    
    value = nil
    body.each do |r|
      r = r.strip.rstrip
      value = r.to_i if /^[-.0-9]*$/ =~ r && value == nil
    end
    bizlog_context = BizLogContext.new(@report_user, @bizmail_kpi, @bizmail_person)
    bizlog = BizLog.new(@report_date, value, nil)
    bizlog_context.insert(bizlog)
  end
  
  def generate_report_mail(&block)
    tmail = TMail::Mail.new
    tmail.content_type = 'text/plain'
    tmail.charset = 'iso-2022-jp'
    tmail.date = Time.now
    tmail.from = @report_user + "@" + $MYDOMAIN
    tmail.reply_to = @report_user + "@" + $MYDOMAIN
    
    if @current_config['type'] == 'single_kpi' then
      bizlog_context = BizLogContext.new(@report_user, @bizmail_kpi, @bizmail_person)
      biztarget_context = BizTargetContext.new(@report_user, @bizmail_kpi, @bizmail_person)
      report_gen = SingleKPIReportGenerator.new(bizlog_context, biztarget_context, $BIZMAIL_DIR + @current_config['report'])
      (subject, body) = report_gen.generate_report(@report_date)
    elsif @current_config['type'] == 'multi_kpi' then
      return nil
    elsif @current_config['type'] == 'aggregated_persons' then
      if @current_config['report'] != nil then
        bizlog_context = BizLogContext.new(@report_user, @bizmail_kpi, @bizmail_person)
        biztarget_context = BizTargetContext.new(@report_user, @bizmail_kpi, @bizmail_person)
        report_gen = SingleKPIReportGenerator.new(bizlog_context, biztarget_context, $BIZMAIL_DIR + @current_config['report'])
        (subject, body) = report_gen.generate_report(@report_date)
      else
        return nil
      end
    end
    
    tmail.to = to_addr_substitute(@current_config['report_to'], @report_from)
    tmail.subject = '=?ISO-2022-JP?B?' + NKF.nkf('-j', subject).split(//, 1).pack('m').chomp + '?='
    tmail.body = NKF.nkf("--jis", body)
    
    block.call(tmail)
  end
  
  def generate_combined_report_mail(&block)
    tmail = TMail::Mail.new
    tmail.content_type = 'text/plain'
    tmail.charset = 'iso-2022-jp'
    tmail.date = Time.now
    tmail.from = @report_user + "@" + $MYDOMAIN
    tmail.reply_to = @report_user + "@" + $MYDOMAIN
    
    if @current_config['type'] == 'single_kpi' then
      return nil
    elsif @current_config['type'] == 'multi_kpi' then
    elsif @current_config['type'] == 'aggregated_persons' then
      blstat = BizLogStatus.new(@report_user)
      reported_persons = blstat.person_status(@report_date, @bizmail_kpi)
      @current_config['person'].each do |k, v|
        return nil if !reported_persons.include?(v)
      end
      
      bizlog_contexts = []
      biztarget_contexts = []
      @current_config['person'].each do |k, v|
        bizlog_contexts.push(BizLogContext.new(@report_user, @bizmail_kpi, v))
        biztarget_contexts.push(BizTargetContext.new(@report_user, @bizmail_kpi, v))
      end
      report_gen = AggregatedPersonsReportGenerator.new(bizlog_contexts, biztarget_contexts, $BIZMAIL_DIR + @current_config['combined_report'])
      (subject, body) = report_gen.generate_report(@report_date)
    end
    
    tmail.to = to_addr_substitute(@current_config['report_to'], @report_from)
    tmail.subject = '=?ISO-2022-JP?B?' + NKF.nkf('-j', subject).split(//, 1).pack('m').chomp + '?='
    tmail.body = NKF.nkf("--jis", body)
    
    block.call(tmail)
  end
  
  def to_addr_substitute(to_addrs, from)
    ret = []
    to_addrs.each do |t|
      t = from if t == '__FROM__'
      ret.push(t)
    end
    
    return ret
  end
end

if __FILE__ == $0 then
require 'rubygems'
require 'date'
require 'date-util'

$DBFILE = "/Users/hiropipi/Documents/workspace/BizMail/dbfile.sqlite3"

processor = BizMailProcessor.new
processor.parse_mail("hiropipi1111@gmail.com", "user01+20110920-k1-p2@dmail.pgw.jp",
                     Date.new(2011, 9, 20), "THIS IS TEST", "5555")
                     
processor.generate_report_mail
processor.generate_combined_report_mail

end
