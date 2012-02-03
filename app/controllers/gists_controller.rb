class GistsController < ApplicationController
  def index
    @gists = User.find_by_username(params[:user_id]).github_gists
    respond_to do |format|
      format.json { render :json => @gists }
    end
  end
end
