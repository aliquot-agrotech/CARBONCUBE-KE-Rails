# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        json_response({ message: e.message }, :not_found)
      end
  
      rescue_from ExceptionHandler::AuthenticationError do |e|
        json_response({ message: e.message }, :unauthorized)
      end
    end
  
    class AuthenticationError < StandardError; end
    class RecordNotFound < StandardError; end
  end
  