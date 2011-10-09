require 'erb'
require 'nkf'

$TEXT_WIDTH = 20

class ReportGenerator 
  def initialize(erbfile)
    erb = ERB.new(File.read(erbfile))
    erb.def_method(ReportGenerator, :_gen_report, erbfile)
  end
  
  def generate_report(date)
    @date = date
    report = _gen_report.split("\n")
    subject = report[0]
    report.shift
    body = report.join("\n")
    return [subject, body]
  end
  
  def value_formatter(value, format)
    if value == nil then
      text = '---'
    elsif format == :integer then
      text = value.to_i.to_s.gsub(/([0-9])(?=([0-9]{3})+(?![0-9]))/) { $1 + ',' }
    elsif format == :fixpoint then
      text = value.to_i.to_s.gsub(/([0-9])(?=([0-9]{3})+(?![0-9]))/) { $1 + ',' } + (value - value.to_i + 0.0000001).to_s[1...3]
    elsif format == :signed_integer then
      text = ''
      text = '+' if value > 0
      text += value.to_i.to_s.gsub(/([0-9])(?=([0-9]{3})+(?![0-9]))/) { $1 + ',' }
    elsif format == :signed_percent then
      text = sprintf("%+.1f%%", value * 100.0)
    elsif format == :percent then
      text = sprintf("%.1f%%", value * 100.0)
    elsif format == :points then
      text = sprintf("%+.1fpt", value * 100.0)
    end
    return text
  end
  
  def print_item(title, value, format)
    text = value_formatter(value, format)
    sp = ' '
    ($TEXT_WIDTH - NKF.nkf('-e', title).length - text.length - 1).times do sp += ' ' end
    
    return title + sp + text
  end

  def print_item2(title, value1, format1, value2, format2)
    text1 = value_formatter(value1, format1)
    text2 = value_formatter(value2, format2)
    sp = ' '
    ($TEXT_WIDTH - NKF.nkf('-e', title).length - text1.length - text2.length - 2).times do sp += ' ' end
    
    return title + sp + text1 + ' ' + text2
  end
  
  attr_reader :date
end
