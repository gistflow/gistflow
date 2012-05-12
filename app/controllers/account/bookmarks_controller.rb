class Account::BookmarksController < ApplicationController
  before_filter :authenticate!
  respond_to :json
  
  def create
    @bookmark = current_user.bookmarks.create(params[:bookmark])
    render_link
  end
  
  def destroy
    @bookmark = current_user.bookmarks.find(params[:id]).destroy
    render_link
  end
  
protected
  
  def render_link
    link = render_to_string(inline: "<%= link_to_bookmark(@bookmark.post) %>")
    render json: { replaceable: link }
  end
end