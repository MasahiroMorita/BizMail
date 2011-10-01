class BizLogStatus
  def initialize(user)
    @db = SQLite3::Database.new($DBFILE)
    @user = user
  end
  
  def kpi_status(date, person)
    array = []
    @db.query("select kpi_id from biz_log_storage where user_id='#{@user}' and person_id='#{person}' and date='#{date.to_stdfmt}' group by kpi_id") do |q|
      q.each do |r|
        array.push(r[0])
      end
    end
    return array
  end
  
  def person_status(date, kpi)
    array = []
    @db.query("select person_id from biz_log_storage where user_id='#{@user}' and kpi_id='#{kpi}' and date='#{date.to_stdfmt}' group by person_id") do |q|
      q.each do |r|
        array.push(r[0])
      end
    end
    return array
  end
end