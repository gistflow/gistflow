class String
  def wrap_with_spaces
    " #{self} "
  end
end

class ReplaceableString < String
  attr_accessor :replaceable
  
  def replaceable?
    !!@replaceable
  end
end
