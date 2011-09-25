require 'biz_target_context.rb'

class TotaledBizTargetContext
  def initialize(biztarget_contexts)
    @biztarget_contexts = biztarget_contexts
  end
  
  def fetch(start_date, end_date = nil)
    @biztarget_contexts.each do |b|
      b.fetch(start_date, end_date)
    end
  end
  
  def sum_target
    sum = 0
    @biztarget_contexts.each do |b|
      sum += b.sum_target
    end
    return sum
  end
  
  def target_at_date(date)
    sum = 0
    @biztarget_contexts.each do |b|
      sum += b.target_at_date(date).value
    end
    return BizLog.new(date, sum, nil, date)
  end
end