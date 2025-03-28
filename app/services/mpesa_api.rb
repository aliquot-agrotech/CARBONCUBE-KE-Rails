require 'httparty'
require 'base64'

class MpesaApi  
  BASE_URL = "https://sandbox.safaricom.co.ke" # Use live URL in production

  def self.get_access_token
    credentials = Base64.strict_encode64("#{ENV['MPESA_CONSUMER_KEY']}:#{ENV['MPESA_CONSUMER_SECRET']}")
    response = HTTParty.get(
      "#{BASE_URL}/oauth/v1/generate?grant_type=client_credentials",
      headers: { "Authorization" => "Basic #{credentials}" }
    )
    response.code == 200 ? JSON.parse(response.body)["access_token"] : nil
  end

  def self.register_urls
    access_token = get_access_token
    return unless access_token

    response = HTTParty.post(
      "#{BASE_URL}/mpesa/c2b/v1/registerurl",
      headers: {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json"
      },
      body: {
        ShortCode: ENV['MPESA_SHORTCODE'],
        ResponseType: "Completed",
        ConfirmationURL: "https://carboncube-ke.com/mpesa/confirm",
        ValidationURL: "https://carboncube-ke.com/mpesa/validate"
      }.to_json
    )
    response.body
  end
end
