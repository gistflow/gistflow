class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(params[:comment])
    comment.user = current_user
    if comment.save
      redirect_to post_path(post)
    else
      @presenter = Posts::ShowPresenter.new(post)
      render :'posts/show'
    end
  end
end
