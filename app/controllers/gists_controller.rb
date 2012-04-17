class GistsController < ApplicationController
  respond_to :json
  
  def show
    @gist = Github::Gist.find(params[:id])
    respond_with @gist
  end
end
