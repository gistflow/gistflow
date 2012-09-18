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
  has_many :flow
  
  validates :user, :title, presence: true
  validates :preview, length: { minimum: 3, maximum: 500, too_long: 'is too long. Use <cut> tag to separate preview and text', too_short: 'is too short' }
  validates :tags_size, numericality: { greater_than: 0 }
  validates :status, length: { maximum: 120 }, if: :status?
  
  attr_accessible :title, :content, :question, :status, :is_private
  
  after_create :tweet, if: :status?
  after_create :setup_observing_for_author
  after_create :notify_audience
  before_create :assign_private_key
  after_save :move_to_flow
  
  scope :from_followed_users, lambda { |user| followed_by(user) }
  scope :not_private, where(is_private: false)
  scope :private, where(is_private: true)
  scope :with_privacy, lambda { |author, user|
    where(is_private: false) unless author == user
  }
  
  def to_param
    is_private? ? private_key : "#{id}-#{title.parameterize}"
  end
  
  def self.find_by_param param
    if param.size == 40 && param =~ /[a-z0-9]{40}/
      Post.find_by_private_key! param
    else
      Post.where(is_private: false).find param[/^(\d+)/, 1]
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
  
  def audience
    is_private? ? [] : begin
      User.mailable.find_all do |user|
        user.flow.include?(self) && user != self.user
      end.uniq
    end
  end
  
  def path
    "/posts/#{to_param}"
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
    comments.order(:id).includes(:user).to_a.select(&:persisted?)
  end
  
  def usernames
    [*persisted_comments.map { |c| c.user.username }, user.username].uniq.sort
  end
  
private
  
  def after_mark_deleted
    flow.destroy_all
    true
  end

  def move_to_flow
    return true if mark_deleted?
    
    # to author
    flow.where(user_id: user_id).first_or_create!
    
    # to followers
    unless is_private?
      user_ids = user.follower_ids
      flow.where(user_id: user.follower_ids).first_or_create! if user_ids.any?
    end
    
    # to subscribers
    unless is_private?
      conditions = { subscriptions: { tag_id: tag_ids } }
      user_ids = User.joins(:subscriptions).where(conditions).pluck("users.id")
      flow.where(user_id: user_ids).first_or_create! if user_ids.any?
    end
    
    true
  end
  
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
    self.private_key = Digest::SHA1.hexdigest(rand.to_s)
  end
  
  def notify_audience
    Resque.enqueue(Mailer, 'UserMailer', :new_post, id)
  end
end
