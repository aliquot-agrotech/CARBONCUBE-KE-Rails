# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false

  attr_reader :current_user

  def home
    respond_to do |format|
      format.json { render json: { message: "API is up and running" }, status: :ok }
      # You can add other formats here if needed, but for API, we usually focus on `json`.
    end
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
