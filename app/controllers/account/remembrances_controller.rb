class Account::RemembrancesController < ApplicationController
  before_filter :authenticate!, :only => :index
  respond_to :json
  
  def index
    @posts = current_user.remembrance.page(params[:page])
  end
  
  def show
    options = {
      :partial => 'sidebar.html.slim',
      :layout => false
    }
    respond_with div: render_to_string(options)
  end
end