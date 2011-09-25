class TargetKPICalculator
  def initialize(bizlog_context, biztarget_context, date)
    @bizlog_context = bizlog_context
    @biztarget_context = biztarget_context
    @date = date
  end

  def daily_target
    @biztarget_context.fetch(date)
    return @biztarget_context.sum_target
  end

  def daily_ratio
    @bizlog_context.fetch(date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(date)
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value * 1.0 / target
  end

  def monthly_target
    @biztarget_context.fetch(Date.new(@date.year, @date.month, 1), Date.new(@date.year, @date.month, -1))
    return @biztarget_context.sum_target
  end

  def monthly_ratio
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(Date.new(@date.year, @date.month, 1), Date.new(@date.year, @date.month, -1))
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value * 1.0 / target
  end

  def weekly_target
    @biztarget_context.fetch(@date.last_monday, (@date+7).last_monday)
    return @biztarget_context.sum_target
  end

  def weekly_ratio
    @bizlog_context.fetch(@date.last_monday, @date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(@date.last_monday, (@date+7).last_monday)
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value * 1.0 / target
  end
  
  def monthly_BVA
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(Date.new(@date.year, @date.month, 1), Date.new(@date.year, @date.month, -1))
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value - target
  end

  def weekly_BVA
    @bizlog_context.fetch(@date.last_monday, @date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(@date.last_monday, (@date+7).last_monday)
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value - target
  end

  def daily_BVA
    @bizlog_context.fetch(date)
    value = @bizlog_context.sum_value
    
    @biztarget_context.fetch(date)
    target = @biztarget_context.sum_target
    
    return nil if value == nil || target == nil || target == 0
    return value - target
  end
end