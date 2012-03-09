class GistsBuilder < ViewBuilder
  delegate :github_gists, :to => :user
  
  def wrap(options = {}, &block)
    options[:'data-url'] ||= wrap_data_url
    super(options, &block)
  end
  
  def title
    super 'Your Gists'
  end
  
  def gists
    options[:load_gists] ? list_of_gists : link_to_gists
  end
  
protected
  
  def wrap_class
    'gists'
  end

  def wrap_data_url
    url_helpers.user_gists_path(user, :format => :json) if user
  end

  def list_of_gists
    content_tag(:ul) do
      github_gists.map do |gist|
        content_tag(:li) do
          options = {
            :class            => 'importable-gist',
            :'data-gist-id'   => gist.id,
            :'data-gist-lang' => gist.lang
          }
          link_to(gist.id, '#', options).concat " #{gist.description}"
        end
      end.join.html_safe
    end
  end
  
  def highlight?
    params[:action] == 'new'
  end

  def link_to_gists
    title, url = "#{username}'s gists", "https://gist.github.com/#{username}"
    link_to(title, url).concat(" on Github")
  end
  
  def show?
    user and params[:controller] != 'users'
  end
end
