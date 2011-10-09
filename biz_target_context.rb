require 'date'
require 'date-util'
#require 'sqlite3'

class BizTargetContext
  def initialize(user, kpi, person)
    @db = SQLite3::Database.new($DBFILE)
    @user = user
    @kpi = kpi
    @person = person
    @item = person
    @fetched_records = nil
    @fetched_date = nil
    @fetched_period = nil
  end
  
  def fetch(start_date, end_date = nil)
    return if @fetched_records && @fetched_start_date == start_date && @fetched_end_date == end_date
    @fetched_start_date = start_date
    @fetched_end_date = end_date
    @fetched_records.close if @fetched_records
    @fetched_records = @db.query("select date, value from biz_target_storage where #{_build_where_clause(start_date, end_date)} order by date")
  end

  def sum_target
    return nil if @fetched_records == nil
    sum = 0
    @fetched_records.reset
    @fetched_records.each do |r|
      sum += r[1].to_f
    end
    return sum
  end
  
  def target_at_date(date)
    return nil if @fetched_records == nil
    @fetched_records.reset
    @fetched_records.each do |r|
      return BizLog.new(Date.parse(r[0]), r[1].to_f, nil) if r[0] == date.to_stdfmt
    end
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

my_storage = BizTargetContext.new("user01", "kpi1", "person01")

my_storage.fetch(Date.new(Date.today.year, Date.today.month, 1), Date.new(Date.today.year, Date.today.month, -1))
p my_storage.sum_target
end