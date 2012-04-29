class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    
    render_preview and return if params[:commit] == 'Write'
    if @comment.save
      render_create
    else
      render_json_error("We are sorry, but comment couldn't be saved.")
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