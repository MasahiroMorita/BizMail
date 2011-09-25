class CombinedRatioBizLogContext
  def initialize(bizlog_context1, bizlog_context2)
    @bizlog_context1 = bizlog_context1
    @bizlog_context2 = bizlog_context2
  end
  
  def fetch(start_date, end_date = nil)
    @bizlog_context1.fetch(start_date, end_date)
    @bizlog_context2.fetch(start_date, end_date)
  end
  
  def sum_value
    sum1 = @bizlog_context1.sum_value
    sum2 = @bizlog_context2.sum_value
    return sum1 / sum2
  end
  
  def average_value
    sum_value
  end
  
  def count
    @bizlog_context1.count
  end
  
  def value_at_date(date)
    val1 = @bizlog_context1.value_at_date(date)
    val2 = @bizlog_context2.value_at_date(date)
    BizLog.new(date, val1.value / val2.value, nil, date)
  end
end