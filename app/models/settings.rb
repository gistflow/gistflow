class Settings < ActiveRecord::Base
  attr_accessible :default_wall
  
  WALLS = %w(all flow following)
  
  belongs_to :user
  validates :default_wall, :inclusion => { :in => WALLS }
  
  def default_wall
    self[:default_wall] || 'flow'
  end
end