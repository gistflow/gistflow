class Post < ActiveRecord::Base
  include Models::Taggable
  include Models::Mentionable
  include Models::Indestructible
  
  CUT = /<cut(\stext\s?=\s?\\?[\",']([^[\",',\\]]*)\\?[\",']\s?)?>/
  
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
  
  def preview
    content_parts.first.to_s.strip
  end
  
  def body
    content.sub(CUT, "\r\n")
  end
  
  def tags_size
    raw = Replaceable.new(content)
    raw.tagnames.size
  end
  
  def status?
    status.present?
  end
  
  def preview_cache
    (read_attribute(:preview_cache) || cache_preview).html_safe
  end
  
  def self.followed_by(user)
    followed_user_ids = %(SELECT followed_user_id FROM followings
                           WHERE follower_id = :user_id)
    where("user_id IN (#{followed_user_ids})", { user_id: user })
  end
  
  def self.search(text)
    where("title like :q or content like :q", q: "%#{text}%")
  end
  
  def cut_text
    if content_parts.size > 1
      content[CUT, 2] || I18n.translate(:default_cut)
    end
  end
protected
  
  def cache_preview
    preview = Markdown.markdown(begin
      raw = Replaceable.new(self.preview)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
    
    preview << %(<a href="/posts/#{id}">#{cut_text}</a>).html_safe if cut_text
    write_attribute(:preview_cache, preview)
  end
  
  def content_parts
    m = content.split(CUT, 2)
    @content_parts ||= [m.first, m.last].uniq.compact
  end
  
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
