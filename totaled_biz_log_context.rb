require 'biz_log_context.rb'

class TotaledBizLogContext
  def initialize(bizlog_contexts)
    @bizlog_contexts = bizlog_contexts
  end
  
  def fetch(start_date, end_date=nil)
    @bizlog_contexts.each do |b|
      b.fetch(start_date, end_date)
    end
  end
  
  def sum_value
    sum = 0
    @bizlog_contexts.each do |b|
      sum += b.sum_value
    end
    return sum
  end

  def average_value
    return sum_value / count
  end
  
  def value_at_date(date)
    sum = 0
    @bizlog_contexts.each do |b|
      sum += b.value_at_date(date).value
    end
    return BizLog.new(date, sum, nil, date)
  end
  
  def count
    c = 0
    @bizlog_contexts.each do |b|
      c += b.count
    end
    return c
  end
end