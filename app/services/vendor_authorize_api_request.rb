class VendorAuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def result
    @vendor ||= find_vendor
  end

  private

  def find_vendor
    vendor_id = decoded_token[:user_id] if decoded_token.present?

    if vendor_id
      vendor = Vendor.find_by(id: vendor_id)
      return vendor if vendor
    end

    vendor_email = decoded_token[:email] if decoded_token.present?

    if vendor_email
      vendor = Vendor.find_by(email: vendor_email)
      return vendor if vendor
    end

    raise ExceptionHandler::InvalidToken, 'Invalid token'
  end

  def decoded_token
    @decoded_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    authorization_header = @headers['Authorization']
    if authorization_header.present?
      return authorization_header.split(' ').last
    else
      raise ExceptionHandler::MissingToken, 'Missing token'
    end
  end
end
