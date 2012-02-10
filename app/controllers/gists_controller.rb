class GistsController < ApplicationController
  before_filter :authenticate!
  
  respond_to :json
  
  def index
    @gists = current_user.github_gists
    respond_with div: render_to_string('index.html.haml', layout: false)
  end
  
  def show
    @gist = Github::Gist.find(params[:id])
    respond_to do |format|
      format.json { render :json => @gist }
    end
  end
end
