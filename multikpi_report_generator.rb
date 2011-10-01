require 'report_generator.rb'


class MultiKPIReportGenerator < ReportGenerator
  def initialize(bizlog_contexts, biztarget_contexts, erb_file)
    @bizlog_contexts = bizlog_contexts
    @biztarget_contexts = biztarget_contexts
    super(erb_file)
  end
  
  def generate_report(date)
    @kpi = Hash.new
    
    @bizlog_contexts.each do |b|
      tg = nil
      @biztarget_contexts.each do |t|
        tg = t if t && t.kpi == b.kpi
      end
      @kpi[b.kpi] = KPIStatus.new(KPIStatusCalculator.new(b, date), TargetKPICalculator.new(b, tg, date))
    end
    
    super(date)
  end
  
  attr_reader :kpi
end