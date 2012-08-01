class Post < ActiveRecord::Base
  include Models::Taggable
  include Models::Mentionable
  include Models::Indestructible
  include Models::Cuttable
  
  default_scope order('posts.id desc')
  
  belongs_to :user, inverse_of: :posts
  has_many :comments
  has_many :observings
  has_many :bookmarks
  has_many :likes
  
  validates :user, :title, presence: true
  validates :preview, length: { minimum: 3, maximum: 500, too_long: 'is too long. Use <cut> tag to separate preview and text.', too_short: 'is too short.' }
  validates :tags_size, numericality: { greater_than: 0 }
  validates :status, length: { maximum: 120 }, if: :status?
  
  attr_accessor :is_private
  attr_accessible :title, :content, :question, :status, :is_private
  
  after_create :tweet, if: :status?
  after_create :setup_observing_for_author
  before_save :assign_private_key
  
  scope :from_followed_users, lambda { |user| followed_by(user) }
  scope :not_private, where(private_key: nil)
  scope :private, where('posts.private_key IS NOT NULL')
  
  def to_param
    private_key? ? private_key : id
  end
  
  def self.find_by_param param
    if param =~ /\A\d+\z/
      Post.find param
    else
      Post.find_by_private_key param
    end
  end
  
  # ActiveRecord::Relation extends method
  def self.to_json_hash(options = nil)
    hash = {}
    all.each do |post|
      hash[post.id] = post.as_json(options)
    end
    hash.to_json
  end
  
  def is_private
    @is_private ||= false
  end
  
  # Max updated_at value for cache
  # ActiveRecord::Relation extends method
  def self.last_modified
    all.map(&:updated_at).max.utc
  end
  
  def available_symbols_for_status
    120 - status.to_s.length
  end
  
  def cache_key(type)
    "post:#{id}:#{type}"
  end
  
  def path
    "/posts/#{id}"
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
    user_ids = user.followings.select(:followed_user_id).to_sql
    where "user_id IN (#{user_ids})"
  end
  
  def self.search(text)
    where("title like :q or content like :q", q: "%#{text}%")
  end
  
  def persisted_comments
    comments.includes(:user).to_a.select(&:persisted?)
  end
  
  def usernames
    [*persisted_comments.map { |c| c.user.username }, user.username].uniq.sort
  end
  
private
  
  def tweet
    if user.twitter_client?
      url = Googl.shorten("http://gistflow.com/posts/#{id}")
      status << " " << url.short_url # http://goo.gl/xxxxxx
      user.twitter_client.update(status)
    end
  end
  
  def setup_observing_for_author
    user.observings.create do |observing|
      observing.post = self
    end
    true
  end
  
  def assign_private_key
    if self.is_private
      self.private_key = Digest::SHA1.hexdigest(
        Time.now.to_s.concat Configuration.private_key_salt
      )
    else
      self.private_key = nil
    end
  end
end
