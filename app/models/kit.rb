class Kit < ActiveRecord::Base
  GROUPS = [:Languages, :Frameworks, :Topics]
  
  has_and_belongs_to_many :tags
  has_many :user_kits
  has_many :users, :through => :user_kits
  
  validates :name, :presence => true
  
  scope :sorted, order('group_position, position')
  
  def group
    GROUPS[group_position]
  end
end
