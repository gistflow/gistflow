class String
  def wrap_with_spaces
    " #{self} "
  end
  
  def first(num = 1)
    self[0, num]
  end
  
  def last(num = 1)
    self[-num, num]
  end
end
