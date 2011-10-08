class Date
  def last_monday
    if self.wday >= 1 then
      self - self.wday + 1
    else
      self - 6
    end
  end

  def to_stdfmt
    self.strftime("%Y-%m-%d 00:00:00")
  end

  def wday_name
    ['日', '月', '火', '水', '木', '金', '土'][self.wday]
  end
  
  def to_yymmddaaa
    self.strftime("%Y/%m/%d") + "(" + self.wday_name + ")"
  end
  
  def to_yyyymm
    self.strftime("%Y年%m月")
  end
  
  def to_mmddaaa
    self.strftime("%m/%d") + "(" + self.wday_name + ")"
  end
  
  def to_YYYYMMDD
    self.strftime("%Y%m%d")
  end
end

class DateTime
  def to_stdfmt
    self.strftime("%Y-%m-%d %H:%M:%S")
  end
end