class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_many :subscriptions
  
  validates :name, :presence => true, :format => { :with => /[a-z]+/ }
  
  scope :popular, (lambda do |limit = 100|
    order('taggings_count desc').limit(limit)
  end)
  
  def to_s
    name
  end
  
  def name=(name)
    name.to_s.gsub!(/[\-_]/, '')
    name.downcase!
    write_attribute :name, name
  end
  
  def with_sign
    '#' << name.to_s
  end
  
  def dom_link_id
    'subscr' << name.to_s
  end
  
  def to_param
    name
  end
end
