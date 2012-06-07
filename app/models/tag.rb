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
  has_many :aliases, class_name: :Tag, foreign_key: :entity_id
  belongs_to :entity, class_name: :Tag
  
  has_many :wikis
  
  before_create :build_default_wiki, unless: :wiki
  after_save :relink_related_records_to_entity, if: :alias?
  after_save :resubscribe_users_to_entity, if: :alias?
  
  attr_accessible :name, :entity_id, as: :admin
  
  validates :name, presence: true, format: { with: /[a-z]+/ }
  
  scope :popular, (lambda do |limit = 100|
    order('taggings_count desc').limit(limit)
  end)
  
  def alias?
    !!entity
  end
  
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
  
  def resubscribe_users_to_entity
    subscriptions.each do |subscription|
      conditions = { user_id: subscription.user_id, tag_id: entity_id }
      if Subscription.where(conditions).exists?
        subscription.destroy # don't dublicate subscriptions
      else
        subscription.update_attribute :tag_id, entity_id
      end
    end
    true
  end
  
  def relink_related_records_to_entity
    taggings.each do |tagging|
      conditions = {
        tag_id:        entity_id,
        taggable_type: tagging.taggable_type,
        taggable_id:   tagging.taggable_id
      }
      if Tagging.where(conditions).exists?
        tagging.destroy # don't dublicate taggings
      else
        tagging.update_attribute :tag_id, entity_id
      end
    end
    true
  end
end
