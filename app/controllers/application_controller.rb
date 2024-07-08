# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base  
  skip_before_action :verify_authenticity_token, raise: false # Skip CSRF protection for APIs

  # before_action :authenticate_request # Example authentication check

  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
