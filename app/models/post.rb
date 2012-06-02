class Post < ActiveRecord::Base
  include Models::Taggable
  include Models::Mentionable
  include Models::Indestructible
  include Models::Cuttable
  
  default_scope order: 'posts.id desc'
  
  belongs_to :user, inverse_of: :posts
  has_many :comments
  has_many :observings
  has_many :bookmarks
  has_many :likes
  
  validates :user, :title, presence: true
  validates :preview, length: { minimum: 3, maximum: 500, too_long: 'is too long. Use <cut> tag to separate preview and text.', too_short: 'is too short.' }
  validates :tags_size, numericality: { greater_than: 0 }
  validates :status, format: { with: %r{http://goo.gl/xxxxxx} }, 
    length: { maximum: 140 }, if: :status?
  
  attr_accessor :status
  attr_accessible :title, :content, :question, :status
  
  after_create :tweet
  after_create :setup_observing_for_author
  
  scope :from_followed_users, lambda { |user| followed_by(user) }
  
  # ActiveRecord::Relation extends method
  def self.to_json_hash(options = nil)
    hash = {}
    all.each do |post|
      hash[post.id] = post.as_json(options)
    end
    hash.to_json
  end
  
  # Max updated_at value for cache
  def self.last_modified
    all.map(&:updated_at).map(&:utc).max
  end
  
  def cache_key(type)
    "post:#{id}:#{type}"
  end
  
  def link_name
    ln = title.blank? ? preview : title
    ln[0..30].strip
  end
  
  def title_for_notification post_title = true
    post_title ? title : "post #{id}"
  end
  
  def tags_size
    raw = Replaceable.new(content)
    raw.tagnames.size
  end
  
  def status?
    status.present?
  end
  
  def self.followed_by(user)
    followed_user_ids = %(SELECT followed_user_id FROM followings
                           WHERE follower_id = :user_id)
    where("user_id IN (#{followed_user_ids})", { user_id: user })
  end
  
  def self.search(text)
    where("title like :q or content like :q", q: "%#{text}%")
  end
  
protected
  
  def tweet
    if user.twitter_client? && status.present?
      url = Googl.shorten("http://gistflow.com/posts/#{id}")
      status.gsub!('http://goo.gl/xxxxxx', '')
      status << url.short_url
      user.twitter_client.update(status)
    end
  end
  
  def setup_observing_for_author
    user.observings.create do |observing|
      observing.post = self
    end
    true
  end
end
