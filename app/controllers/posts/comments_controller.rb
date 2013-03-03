class Posts::CommentsController < ApplicationController
  cache_sweeper :user_sweeper
  cache_sweeper :comment_sweeper
  
  def create
    # @post = find_post(params[:post_id])
    # @new_comment = @post.comments.build(params[:comment]) do |comment|
    #   comment.user = current_user
    # end
    # 
    # if @new_comment.save
    #   @comment = @post.comments.build do |comment|
    #     comment.user = current_user
    #   end
    #   render json: { form: render_form(:build), comment: render_comment }
    # else
    #   render_json_error("We are sorry, but comment couldn't be saved.")
    # end
  end
  
  def show
    @comment = Comment.find(params[:id])
    render json: { html: @comment.html }
  end
  
  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
    render json: { content: @comment.content }
  end
  
  def update
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment
    @comment.update_attribute(:content, params[:content])
    render json: { html: @comment.html }
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.mark_deleted
    render json: {}
  end
  
protected
  
  def find_post(id)
    Post.find_by_param id
  end
  
  def render_form(action)
    @action = action
    render_to_string(inline: "<%= render partial: 'form', locals: { comment: @comment, action: @action } %>")
  end
  
  def render_comment
    render_to_string(inline: "<%= render partial: 'comment', locals: { comment: @new_comment } %>")
  end
end