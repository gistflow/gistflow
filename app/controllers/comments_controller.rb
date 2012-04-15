class CommentsController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:create]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    
    #raise params.to_s
    
    render_preview and return if params[:commit] == 'Preview'

    if @comment.save
      render_create# @post
    else
      @presenter = Posts::ShowPresenter.new(@post)
      render 'posts/show'
    end
  end
  
  protected
  def render_preview
    render_json('preview')
  end
  
  def render_create
    render_json('create')
  end
  
  def render_json(action)
    render :json => { 
      :comment => render_to_string(inline: "<%= render :partial => 'comment', :locals => {:comment => @comment} %>"),
      :action => action
    }
  end
  
end
