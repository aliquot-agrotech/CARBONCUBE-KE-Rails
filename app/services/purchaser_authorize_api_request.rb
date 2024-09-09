# app/services/purchaser_authorize_api_request.rb

class PurchaserAuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def result
    @purchaser ||= find_purchaser
  end

  private

  def find_purchaser
    purchaser_id = decoded_token[:user_id] if decoded_token.present?

    if purchaser_id
      purchaser = Purchaser.find_by(id: purchaser_id)
      return purchaser if purchaser
    end

    purchaser_email = decoded_token[:email] if decoded_token.present?

    if purchaser_email
      purchaser = Purchaser.find_by(email: purchaser_email)
      return purchaser if purchaser
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
  end
end
