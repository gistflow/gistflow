class Tip
  TIP_MESSAGES = [
    'Tip about gists',
    'Tip2'
  ]
  
  class << self
    def random
      TIP_MESSAGES[rand TIP_MESSAGES.size]
    end
  end
  
  def initialize(place)
    
  end
end
