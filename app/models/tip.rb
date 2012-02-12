class Tip
  TIP_MESSAGES = [
    'Tip1',
    'Tip2'
  ]
  
  class << self
    def random
      TIP_MESSAGES[rand TIP_MESSAGES.size]
    end
  end
end
