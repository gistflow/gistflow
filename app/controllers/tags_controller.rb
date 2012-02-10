class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name(params[:id])
    @posts = Post.tagged_with(@tag.name).page(params[:page])
    @subscription = current_user.subscriptions.
      find_or_initialize_by_tag_id(@tag.id) if current_user
  end
end