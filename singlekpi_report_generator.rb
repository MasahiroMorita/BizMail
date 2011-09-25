require 'kpi_status_calculator.rb'
require 'target_kpi_calculator.rb'
require 'report_generator.rb'
require 'kpi_status.rb'

class SingleKPIReportGenerator < ReportGenerator
  def initialize(bizlog_context, biztarget_context, erbfile)
    @bizlog_context = bizlog_context
    @biztarget_context = biztarget_context
    super(erbfile)
  end
  
  def generate_report(date)
    @kpistat_calc = KPIStatusCalculator.new(@bizlog_context, date)
    @targetkpi_calc = TargetKPICalculator.new(@bizlog_context, @biztarget_context, date)
    @kpi = KPIStatus.new(@kpistat_calc, @targetkpi_calc)
    
    super(date)
  end
  
  attr_reader :kpi
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
$REPORT_ERB = "/Users/hiropipi/Documents/workspace/BizMail/report.erb"

my_bizlog = BizLogContext.new('user01', 'kpi1', 'person01')
my_target = BizTargetContext.new('user01', 'kpi1', 'person01')

my_report_gen = SingleKPIReportGenerator.new(my_bizlog, my_target, $REPORT_ERB)
puts(my_report_gen.generate_report(Date.new(2011, 9, 19)))

end