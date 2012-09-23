class TimeCounter < ActiveRecord::Base
  MODELS = [:Post, :Comment, :User, :Like, :Tag]

  validates :total_count, :today_count, :date, :model, presence: true
  validates_uniqueness_of :model, scope: :date

  attr_accessible :total_count, :today_count, :date, :model

  scope :for_landing, where('date >= ?', 20.days.ago).order('date ASC')
end