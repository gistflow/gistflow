class Post < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  has_many :comments
  
  default_scope :order => 'id desc'
  
  validates :user, :presence => true
  validates :title, :presence => true
  validates :cuts_count, :inclusion => { :in => [0, 1] }
  validates :preview, :length => 3..500
  
  attr_accessible :title, :content
  
  if Rails.env.production?
    after_create  :create_indextank_document
    after_update  :update_indextank_document
    after_destroy :destroy_indextank_document
  end
  
  class << self
    
    def search(text)
      text.strip!
      query = ["title:#{text}^2", "content:#{text}"].join(' OR ')
      doc_ids = index.search(query)['results'].map do |doc|
        doc['docid']
      end
      where(:id => doc_ids)
    end
    
    def index
      @@index ||= $indextank.indexes(index_name)
    end
    
  protected
    
    def index_name
      Rails.env.production? ? :postsx : :postsx_dev
    end
  end
  
  def short_class_name
    self.class.name.underscore.split('/').last
  end
  
  def link_name
    ln = title.blank? ? preview : title
    ln[0..30].strip
  end
  
  def category
    self.class.name.split('::').last
  end
  
  def controller
    self.class.name.underscore.pluralize
  end
  
  def preview
    content_parts.first.to_s.strip
  end
  
  def body
    content.to_s.gsub('<cut>', "\r\n")
  end
  
protected
  
  def cuts_count
    if content.blank?
      0
    elsif content == '<cut>'
      1
    else
      content.split('<cut>').size - 1
    end
  end
  
  def content_parts
    @content_parts ||= content.to_s.split('<cut>', 2)
  end
  
  def create_indextank_document
    Post.index.document(id).add(title: title, content: content)
  end
  
  def update_indextank_document
    Post.index.document(id).add(title: title, content: content)
  end
  
  def destroy_indextank_document
    Post.index.document(id).delete
  end
end
