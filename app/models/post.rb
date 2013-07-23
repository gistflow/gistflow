class Post < ActiveRecord::Base
  include Models::Taggable
  include Models::Mentionable
  include Models::Indestructible
  include Models::Cuttable
  include Models::Searchable

  default_scope order('posts.id desc')

  belongs_to :user, inverse_of: :posts
  has_many :comments
  has_many :observings
  has_many :bookmarks
  has_many :likes

  validates :user, :title, presence: true
  validates :preview, length: { minimum: 3, maximum: 500, too_long: 'is too long. Use <cut> tag to separate preview and text', too_short: 'is too short' }
  validates :tags_size, numericality: { greater_than: 0 }
  validates :status, length: { maximum: 120 }, if: :status?

  attr_accessible :title, :content, :status, :is_private

  after_create :setup_observing_for_author
  after_commit :notify_audience, on: :create
  before_create :assign_private_key

  scope :from_followed_users, lambda { |user| followed_by(user) }
  scope :not_private, where(is_private: false)
  scope :private, where(is_private: true)
  scope :with_privacy, lambda { |author, user|
    where(is_private: false) unless author == user
  }
  scope :except_post, lambda { |post| where('posts.id != ?', post.id) }
  scope :last_day, where('created_at >= ?', Date.today - 1.day)
  scope :last_week, where('created_at >= ?', Date.today - 1.week)
  scope :last_month, where('created_at >= ?', Date.today - 1.month)

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
    html = Markdown.markdown(content)
    Replaceable.new(html).tagnames.size
  end

  def status?
    status.present?
  end

  def self.followed_by(user)
    user_ids = user.followings.select(:followed_user_id).to_sql
    where "user_id IN (#{user_ids})"
  end

  def persisted_comments
    comments.order(:id).includes(:user).to_a.select(&:persisted?)
  end

  def usernames
    [*persisted_comments.map { |c| c.user.username }, user.username].uniq.sort
  end

  def similar_posts
    subquery = Post.not_private.except_post(self).tagged_with(tags.select(:name)).select('posts.id').to_sql
    Post.where("posts.id IN (#{subquery})").order("RANDOM()").limit(3)
  end

private

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
    audience.each do |user|
      Resque.enqueue(Mailer, 'UserMailer', :new_post, id, user.id)
    end
  end
end
