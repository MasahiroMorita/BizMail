require 'kpi_status_calculator.rb'
require 'target_kpi_calculator.rb'
require 'report_generator.rb'
require 'kpi_status.rb'
require 'totaled_biz_log_context.rb'
require 'totaled_biz_target_context.rb'
require 'array-util.rb'

class AggregatedItemsReportGenerator < ReportGenerator
  def initialize(bizlog_contexts, biztarget_contexts, erb_file)
    @bizlog_contexts = bizlog_contexts
    @biztarget_contexts = biztarget_contexts
    super(erb_file)
  end
  
  def generate_report(date)
    total_log = TotaledBizLogContext.new(@bizlog_contexts)
    total_target = TotaledBizTargetContext.new(@biztarget_contexts)
    
    @total = KPIStatus.new(KPIStatusCalculator.new(total_log, date), TargetKPICalculator.new(total_log, total_target, date))
    @items = []
    
    @bizlog_contexts.each do |b|
      tg = nil
      @biztarget_contexts.each do |t|
        tg = t if t.item == b.item
      end
      @items.push(KPIStatus.new(KPIStatusCalculator.new(b, date), TargetKPICalculator.new(b, tg, date)))
    end
    
    super(date)
  end
  
  attr_reader :total, :items
end
