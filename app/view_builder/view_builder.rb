class ViewBuilder
  attr_reader :user, :params, :options
  
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Context
  include Haml::Helpers
  
  delegate :url_helpers, :to => 'Rails.application.routes'
  delegate :username, :to => :user
  
  def initialize(user, params, options = {})
    @user, @params, @options = user, params, options
    init_haml_helpers
  end
  
  def wrap(options = {}, &block)
    return unless show?
    
    content = capture(&block)
    classes = [wrap_class]
    classes << 'highlight' if highlight?
    
    content_tag(:section, { :class => classes }.reverse_merge(options)) do
      content_tag(:header) do
        content_tag :h1, title
      end << content
    end
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
