class CommentsController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:create]
  
  def create  
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      redirect_to @post
    else
      @presenter = Posts::ShowPresenter.new(@post)
      render 'posts/show'
    end
  end
end
