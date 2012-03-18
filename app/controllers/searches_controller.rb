class SearchesController < ApplicationController
  def create
    search = Search.new(params[:q])
    redirect_to search.page_path
  end
  
  def show
    @posts = Post.includes(:user).search(params[:query]).page(params[:page])
    render :'search/show'
  end
end
