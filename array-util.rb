class Array
  def sorting_by(key)
    return self.sort do |a, b|
      (a.send(key) <=> b.send(key)) * -1.0
    end
  end
end