class Account::ObservingsController < ApplicationController
  before_filter :authenticate!
  respond_to :json
  
  def create
    @observing = current_user.observings.create(params[:observing])
    render_link
  end
  
  def destroy
    @observing = current_user.observings.find(params[:id]).destroy
    render_link
  end
  
protected
  
  def find_post(id)
    Post.find(id)
  end
  
  def render_link
    link = render_to_string(inline: "<%= link_to_observe(@observing.post) %>")
    render json: { replaceable: link }
  end
end