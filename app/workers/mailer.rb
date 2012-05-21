class Mailer
  @queue = :mailer_queue
  
  def self.perform klass, action, *params
    klass.classify.constantize.send(action, *params).deliver
  end
end