class Account::ObservingsController < ApplicationController
  before_filter :authenticate!, only: :index
  respond_to :json
  
  def create
    @observing = current_user.observings.build(params[:observing])
    if @observing.save
      new_link = render_to_string(inline: "<%= link_to_observe(@observing.post) %>")
      render json: { new_link: new_link }
    else
      render json: { errors: @observing.errors.full_messages }
    end
  end
  
  def destroy
    @observing = current_user.observings.find(params[:id])
    @observing.destroy
    new_link = render_to_string(inline: "<%= link_to_observe(@observing.post) %>")
    render json: { new_link: new_link }
  end
end