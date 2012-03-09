class ViewBuilder
  attr_reader :user, :params, :options
  
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Context
  include Haml::Helpers
  
  delegate :url_helpers, :to => 'Rails.application.routes'
  
  def initialize(user, params, options = {})
    @user, @params, @options = user, params, options
    init_haml_helpers
  end
  
  def title(title)
    content_tag(:div, title, :class => :caption)
  end
  
  def wrap(options = {}, &block)
    return unless show?
    
    content = capture(&block)
    classes = ['block', wrap_class]
    classes << 'highlight' if highlight?
    content_tag :div, content, { :class => classes }.reverse_merge(options)
  end
  
protected

  def wrap_class
    'default'
  end
  
  def highlight?
    false
  end
  
  def show?
    true
  end
end
