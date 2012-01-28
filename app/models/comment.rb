class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :consignee, :class_name => 'User'
  belongs_to :post
  
  validates :body, :presence => true
  
  before_save :check_for_consignee
  
  private
  
  def check_for_consignee
    first_word = body.split.first
    if username = first_word.scan(/^@([\w\-]+)$/).first.try(:first)
      if user = User.find_by_username(username)
        self.consignee = user
      end
    end
  end
end
