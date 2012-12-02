class SearchesController < ApplicationController
  def create
    search = Search.new(params[:q])
    redirect_to search.page_path
  end
  
  def show
    @posts = Post.search(params[:query], page: params[:page])
    render :'search/show'
  end
  
  def empty
    render :'search/empty'
  end
end
