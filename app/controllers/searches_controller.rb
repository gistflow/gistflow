class SearchesController < ApplicationController
  def create
    search = Search.new(params[:q])
    redirect_to search.page_path
  end
end
