# app/services/vendor_authorize_api_request.rb

class VendorAuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def result
    @user ||= find_user
  end

  private

  def find_user
    user_id = decoded_token[:user_id] if decoded_token.present?

    if user_id
      user = Vendor.find_by(id: user_id)
      return user if user
    end

    email = decoded_token[:email] if decoded_token.present?

    if email
      user = Vendor.find_by(email: email)
      return user if user
    end

    raise ExceptionHandler::InvalidToken, 'Invalid token'
  end

  def decoded_token
    @decoded_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if @headers['Authorization'].present?
      return @headers['Authorization'].split(' ').last
    else
      raise ExceptionHandler::MissingToken, 'Missing token'
    end
    nil
  end
end
