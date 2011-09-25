require 'kpi_status_calculator.rb'
require 'target_kpi_calculator.rb'
require 'report_generator.rb'
require 'kpi_status.rb'
require 'totaled_biz_log_context.rb'
require 'totaled_biz_target_context.rb'
require 'array-util.rb'

class AggregatedPersonsReportGenerator < ReportGenerator
  def initialize(bizlog_contexts, biztarget_contexts, erb_file)
    @bizlog_contexts = bizlog_contexts
    @biztarget_contexts = biztarget_contexts
    super(erb_file)
  end
  
  def generate_report(date)
    total_log = TotaledBizLogContext.new(@bizlog_contexts)
    total_target = TotaledBizTargetContext.new(@biztarget_contexts)
    
    @total = KPIStatus.new(KPIStatusCalculator.new(total_log, date), TargetKPICalculator.new(total_log, total_target, date))
    @persons = []
    
    @bizlog_contexts.each do |b|
      tg = nil
      @biztarget_contexts.each do |t|
        tg = t if t.person == b.person
      end
      @persons.push(KPIStatus.new(KPIStatusCalculator.new(b, date), TargetKPICalculator.new(b, tg, date)))
    end
    
    super(date)
  end
  
  attr_reader :total, :persons
end

if __FILE__ == $0 then
require 'rubygems'
require 'sqlite3'
require 'biz_log.rb'
require 'biz_log_context.rb'
require 'biz_target_context.rb'
require 'date'
require 'date-util'

$DBFILE = "/Users/hiropipi/Documents/workspace/BizMail/dbfile.sqlite3"
$AGG_REPORT_ERB = "/Users/hiropipi/Documents/workspace/BizMail/agg-report.erb"

person01_bizlog = BizLogContext.new('user01', '売上', '神山')
person01_target = BizTargetContext.new('user01', '売上', '神山')

person02_bizlog = BizLogContext.new('user01', '売上', '森田')
person02_target = BizTargetContext.new('user01', '売上', '森田')

my_report_gen = AggregatedPersonsReportGenerator.new([person01_bizlog, person02_bizlog], [person01_target, person02_target], $AGG_REPORT_ERB)
puts(my_report_gen.generate_report(Date.new(2011, 9, 19)))

end