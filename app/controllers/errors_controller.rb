class ErrorsController < ApplicationController
  layout 'error'
  
  def not_found
    render :not_found, formats: ['html']
  end
end