class GistsController < ApplicationController
  def index
    @gists = current_user.github_gists
    cookies.permanent[:gists] = @gists.map do |g|
      { :id => g.id,
        :description => g.description }
    end.to_json
    respond_to do |format|
      format.json do
        render :json => { :div => render_to_string('index.html.haml', :layout => false) }
      end
    end
  end
  
  def show
    @gist = Github::Gist.find(params[:id])
    respond_to do |format|
      format.json { render :json => @gist }
    end
  end
end
