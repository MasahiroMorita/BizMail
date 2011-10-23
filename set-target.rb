require 'rubygems'
require 'sqlite3'
require 'date'
require 'date-util'
require 'optparse'

parser = OptionParser.new

$action = nil
$date = nil
$start_date = nil
$end_date = nil
$user = nil
$kpi = nil
$person = nil
$value = nil

parser.on('-a', '--add=VALUE', Float, '目標値を日毎に登録する') do |arg|
  $action = :add
  $value = arg
end

parser.on('-c', '--load-csv', '標準入力から目標値を読み込む') do 
  $action = :load_csv
end

parser.on('-l', '--list', '目標値を読み出す') do 
  $action = :list
end

parser.on('-r', '--remove-record', '目標値を削除する') do
  $action = :remove
end

parser.on('-d', '--date=DATE', String, '日付を指定する') do |date|
  $date = Date.parse(date)
end

parser.on('-D', '--date-between=START/END', String, '日付の期間を指定する(yyyy/mm/dd-yyyy/mm/dd)') do |period|
  (start_date, end_date) = period.split(/[- ]/)
  $start_date = Date.parse(start_date)
  $end_date = Date.parse(end_date)
end

parser.on('-u', '--user=USER', String, 'ユーザIDを指定する') do |user|
  $user = user
end

parser.on('-k', '--kpi=KPI名', String, 'KPI名を指定する') do |kpi|
  $kpi = kpi
end

parser.on('-p', '--person=PERSON名', String, 'PERSON名を指定する') do |person|
  $person = person
end

begin
  parser.parse!
  raise OptionParser::ParseError, "処理が指定されていません" unless $action
  raise OptionParser::ParseError, "ユーザIDが指定されていません" unless $user
  
  db = SQLite3::Database.new('dbfile.sqlite3')
  
  if $action == :add && $date then
    record = {:date => $date.to_stdfmt, :user_id => $user, :person_id => $person, :kpi_id => $kpi, :value => $value}
    db.execute("insert into biz_target_storage values (:id, :date, :user_id, :person_id, :kpi_id, :value)",
                record)
  elsif $action == :add && $start_date && $end_date then
    ($end_date - $start_date + 2).to_i.times do |i|
      record = {:date => ($start_date + i - 1).to_stdfmt, :user_id => $user, :person_id => $person, :kpi_id => $kpi, :value => $value}
      db.execute("insert into biz_target_storage values (:id, :date, :user_id, :person_id, :kpi_id, :value)",
                record)
    end
  elsif $action == :load_csv then
  elsif $action == :list && $date then
    records = db.query("select date, kpi_id, person_id, value from biz_target_storage where date = '#{$date.to_stdfmt}' and user_id = '#{$user}'")
    records.each do |r|
      puts "#{r[0].strftime("%Y/%m/%d")}, #{r[1]}, #{r[2]}, #{r[3].to_s}"
    end
  elsif $action == :list && $start_date && $end_date then
    records = db.query("select date, kpi_id, person_id, value from biz_target_storage where date between '#{$start_date.to_stdfmt}' and '#{$end_date.to_stdfmt}' and user_id = '#{$user}'")
    records.each do |r|
      puts "#{Date.parse(r[0]).strftime("%Y/%m/%d")}, #{r[1]}, #{r[2]}, #{r[3].to_s}"
    end
  elsif $action == :remove && $date then
  elsif $action == :remove && $start_date && $end_date then
  end
rescue OptionParser::ParseError => err
  $stderr.puts err.message
  $stderr.puts parser.help
end

