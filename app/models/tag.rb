class Tag < ActiveRecord::Base
  has_many :subscriptions
  has_many :taggings
  has_many :posts, {
    through: :taggings, source: :tag,
    conditions: { taggings: { taggable_type: 'Post' } }
  }
  has_many :comments, {
    through: :taggings, source: :tag,
    conditions: { taggings: { taggable_type: 'Comment' } }
  }
  
  has_many :wikis
  
  before_create :build_default_wiki, unless: :wiki
  
  validates :name, presence: true, format: { with: /[a-z]+/ }
  
  scope :popular, (lambda do |limit = 100|
    order('taggings_count desc').limit(limit)
  end)
  
  def wiki
    @wiki ||= wikis(true).last
  end
  
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
  
  def to_param
    name
  end
  
protected
  
  def build_default_wiki
    wikis.build do |wiki|
      wiki.user    = User.gistflow
      wiki.content = 'Nothing to display jet.'
    end
  end
end
