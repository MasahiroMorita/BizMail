class BizLog
  def initialize(date, value, memo, timestamp = nil)
    @date = date
    @value = value
    @memo = memo
    @timestamp = timestamp
    @timestamp = DateTime.now if timestamp == nil
  end
  
  attr_reader :date, :value, :memo, :timestamp
end