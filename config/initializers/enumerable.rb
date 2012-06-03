module Enumerable
  def each_with_previous
    last_element = nil
    each do |e|
      yield e, last_element
      last_element = e
    end
  end
end
