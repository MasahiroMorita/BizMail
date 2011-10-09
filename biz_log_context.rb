require 'sqlite3'
require 'date'
require 'date-util'

class BizLogContext
  def initialize(user, kpi, person)
    @db = SQLite3::Database.new($DBFILE)
    @user = user
    @kpi = kpi
    @person = person
    @item = person
    @fetched_records = nil
    @fetched_start_date = nil
    @fetched_end_date = nil
  end
  
  def insert(bizlog)
    @db.execute("delete from biz_log_storage where #{_build_where_clause(bizlog.date)}")
    @db.execute("insert into biz_log_storage values (:id, :date, :timestamp, :user_id, :person_id, :kpi_id, :value, :memo)",
      {:date=>bizlog.date.to_stdfmt, :timestamp=>bizlog.timestamp.to_stdfmt, :user_id=>@user, :person_id=>@person, :kpi_id=>@kpi, :value=>bizlog.value, :memo=>bizlog.memo})
  end
  
  def fetch(start_date, end_date=nil)
    return if @fetched_records && @fetched_start_date == start_date && @fetched_end_date == end_date
    @fetched_start_date = start_date
    @fetched_end_date = end_date
    @fetched_records.close if @fetched_records
    @fetched_records = @db.query("select date, value, memo, timestamp from biz_log_storage where #{_build_where_clause(start_date, end_date)} order by date")
  end

  def sum_value
    return nil if @fetched_records == nil
    @fetched_records.reset
    sum = 0
    @fetched_records.each do |r|
      sum += r[1].to_f
    end
    return sum
  end
  
  def average_value
    return nil if @fetched_records == nil || count == 0
    return sum_value / count
  end
  
  def value_at_date(date)
    return nil if @fetched_records == nil
    @fetched_records.reset
    @fetched_records.each do |r|
      return BizLog.new(Date.parse(r[0]), r[1].to_f, r[2], DateTime.parse(r[3])) if r[0] == date.to_stdfmt
    end
    return nil
  end
  
  def count
    i = 0
    @fetched_records.reset
    @fetched_records.each do i += 1 end
    return i
  end
  
  def _build_where_clause(start_date, end_date=nil)
    sql = "user_id='#{@user}' and kpi_id='#{@kpi}' and person_id='#{@person}' "
    if end_date == nil
      sql += "and date='#{start_date.to_stdfmt}'"
    else
      sql += "and date between '#{start_date.to_stdfmt}' and '#{end_date.to_stdfmt}'"
    end
  end
  
  attr_reader :person, :kpi, :item
end

if __FILE__ == $0 then
require 'rubygems'
require 'biz_log.rb'

$DBFILE = "/Users/hiropipi/Documents/workspace/BizMail/dbfile.sqlite3"

my_storage = BizLogContext.new("user01", "kpi1", "person01")

#bizlog = BizLog.new(Date.today-1, 1234, "this is memo.")
#my_storage.insert(bizlog)
#my_storage.insert(bizlog)

my_storage.fetch(Date.new(2011, 9, 1), Date.new(2011, 9, 19))
p my_storage.sum_value
p my_storage.person_status(Date.today)
p my_storage.count
p my_storage.kpi_status(Date.today)
end