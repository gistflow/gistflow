class SearchesController < ApplicationController
  def create
    search = Search.new(params[:q])
    redirect_to search.page_path
  end
  
  def show
    @posts = Post.not_private.includes(:user).
      search(params[:query]).page(params[:page])
      
    flash[:info] = 'You can search by #tag or @username'
    render :'search/show'
  end
  
  def empty
    render :'search/empty'
  end
end
