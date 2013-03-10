class Posts::CommentsController < ApplicationController
  cache_sweeper :user_sweeper
  cache_sweeper :comment_sweeper
  
  def create
    @post = find_post(params[:post_id])
    @comment = @post.comments.build(params[:comment]) do |comment|
      comment.user = current_user
    end
    if @comment.save
      render json: {}, status: :created
    else
      errors = @comment.errors.to_a.to_sentence
      render text: errors, status: :unprocessable_entity
    end
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
end