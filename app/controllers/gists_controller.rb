class GistsController < ApplicationController
  before_filter :authenticate!, :only => :index
  respond_to :json
  
  def index
    options = {
      :partial => 'sidebar.html.haml',
      :layout => false,
      :locals => { :load_gists => true }
    }
    respond_with div: render_to_string(options)
  end
  
  def show
    @gist = Github::Gist.find(params[:id])
    respond_with @gist
  end
end
