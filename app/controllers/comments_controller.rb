class CommentsController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:create]
  
  def create  
    post = Post.find(params[params.keys.select{ |k| k =~ /_id$/ }.first])
    comment = post.comments.build(params[:comment])
    comment.user = current_user
    if comment.save
      redirect_to :controller => post.controller, :action => :show, :id => post.id
    else
      @presenter = Posts::ShowPresenter.new(post)
      render 'post/show'
    end
  end
end
