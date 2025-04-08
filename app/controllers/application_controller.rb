# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base  
  # Skip CSRF protection for APIs (API-only configuration)
  skip_before_action :verify_authenticity_token, raise: false

  # Optionally, you can uncomment the following for authentication
  # before_action :authenticate_request # Uncomment if needed for authentication

  attr_reader :current_user

  # New home action to handle root path request (API status)
  def home
    render json: { message: "API is up and running" }, status: :ok
  end

  private

  # Optional authentication logic (uncomment if needed)
  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
