class KPIStatusCalculator
  def initialize(bizlog_context, date)
    @bizlog_context = bizlog_context
    @date = date
  end

  def kpi
    @bizlog_context.kpi
  end
  
  def person
    @bizlog_context.person
  end

  def item
    @bizlog_context.item
  end
  
  def consume_rate
    return @date.day * 1.0 / (Date.new(@date.year, @date.month, -1) - Date.new(@date.year, @date.month, 1) + 1)
  end

  def daily_data(j = 0)
    @bizlog_context.fetch(@date - j)
    return @bizlog_context.value_at_date(@date - j).value if @bizlog_context.value_at_date(@date - j)
    nil
  end
  
  def monthly_sum
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    return @bizlog_context.sum_value
  end

  def monthly_average
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    return @bizlog_context.average_value
  end
  
  def daily_MoM
    @bizlog_context.fetch(@date)
    this_month = @bizlog_context.sum_value
    
    if @date.day > Date.new(@date.year, @date.month-1, -1).day then
      @bizlog_context.fetch(Date.new(@date.year, @date.month-1, -1))
    else
      @bizlog_context.fetch(Date.new(@date.year, @date.month-1, @date.day))
    end
    last_month = @bizlog_context.sum_value
    
    return nil if this_month == nil || last_month == nil || last_month == 0
    return this_month * 1.0 / last_month - 1.0;
  end

  def monthly_MoM
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    this_month = @bizlog_context.sum_value
    
    if @date.day > Date.new(@date.year, @date.month-1, -1).day then
      @bizlog_context.fetch(Date.new(@date.year, @date.month-1, 1), Date.new(@date.year, @date.month-1, -1))
    else
      @bizlog_context.fetch(Date.new(@date.year, @date.month-1, 1), Date.new(@date.year, @date.month-1, @date.day))
    end
    last_month = @bizlog_context.sum_value
    
    return nil if this_month == nil || last_month == nil || last_month == 0
    return this_month * 1.0 / last_month - 1.0;
  end

  def daily_YoY 
    @bizlog_context.fetch(@date)
    this_year = @bizlog_context.sum_value
    
    @bizlog_context.fetch(Date.new(@date.year-1, @date.month, @date.day))
    last_year = @bizlog_context.sum_value

    return nil if this_year == nil || last_year == nil || last_year == 0
    return this_year * 1.0 / last_year - 1.0;
  end
  
  def monthly_YoY
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    this_year = @bizlog_context.sum_value
    
    @bizlog_context.fetch(Date.new(@date.year-1, @date.month, 1), Date.new(@date.year-1, @date.month, @date.day))
    last_year = @bizlog_context.sum_value

    return nil if this_year == nil || last_year == nil || last_year == 0
    return this_year * 1.0 / last_year - 1.0;
  end
  
  def weekly_sum
    @bizlog_context.fetch(@date.last_monday, @date)
    return @bizlog_context.sum_value
  end

  def weekly_average
    @bizlog_context.fetch(@date.last_monday, @date)
    return @bizlog_context.average_value
  end
  
  def daily_WoW
    @bizlog_context.fetch(@date)
    this_week = @bizlog_context.sum_value
    
    @bizlog_context.fetch(@date-7)
    last_week = @bizlog_context.sum_value
    
    return nil if this_week == nil || last_week == nil || last_week == 0
    return this_week * 1.0 / last_week - 1.0
  end
  
  def weekly_WoW
    @bizlog_context.fetch(@date.last_monday, @date)
    this_week = @bizlog_context.sum_value
    
    @bizlog_context.fetch((@date-7).last_monday, @date-7)
    last_week = @bizlog_context.sum_value
    
    return nil if this_week == nil || last_week == nil || last_week == 0
    return this_week * 1.0 / last_week - 1.0
  end
  
  def monthly_remaining_days
    return Date.new(@date.year, @date.month, -1).day - @date.day
  end
  
  def monthly_average_diff
    @bizlog_context.fetch(Date.new(@date.year, @date.month, 1), @date)
    this_month = @bizlog_context.average_value
    
    @bizlog_context.fetch(Date.new(@date.year, @date.month-1, 1),
    			  Date.new(@date.year, @date.month-1, -1))
    last_month = @bizlog_context.average_value
    
    return nil if this_month == nil || last_month == nil || last_month == 0
    return this_month - last_month
  end
end

if __FILE__ == $0 then
require 'rubygems'
require 'sqlite3'
require 'biz_log.rb'
require 'biz_log_context.rb'
require 'date'
require 'date-util'

$DBFILE = "/Users/hiropipi/Documents/workspace/BizMail/dbfile.sqlite3"

my_storage = BizLogContext.new("user01", "kpi1", "person01")
my_calc = KPIStatusCalculator.new(my_storage, Date.new(2011, 9, 19))
p my_calc.consume_rate
p my_calc.daily_data(0)
p my_calc.monthly_sum
p my_calc.monthly_average
p my_calc.daily_WoW

end
