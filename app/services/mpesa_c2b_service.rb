require 'httparty'
require 'base64'

class MpesaC2bService
  # BASE_URL_API = Rails.env.production? ? "https://api.safaricom.co.ke" : "https://sandbox.safaricom.co.ke"
  # 

  BASE_URL_API = "https://sandbox.safaricom.co.ke" # Use "https://api.safaricom.co.ke" in production

  def self.access_token
    credentials = Base64.strict_encode64("#{ENV['MPESA_CONSUMER_KEY']}:#{ENV['MPESA_CONSUMER_SECRET']}")
    
    response = HTTParty.get(
      "#{BASE_URL_API}/oauth/v1/generate?grant_type=client_credentials",
      headers: { "Authorization" => "Basic #{credentials}" }
    )

    if response.code == 200
      token = JSON.parse(response.body)["access_token"]
      Rails.logger.info("✅ M-Pesa Access Token Retrieved")
      token
    else
      Rails.logger.error("❌ Failed to retrieve access token: #{response.body}")
      nil
    end
  end

  def self.register_urls
    token = access_token
    return unless token

    response = HTTParty.post(
      "#{BASE_URL_API}/mpesa/c2b/v1/registerurl",
      headers: {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json"
      },
      body: {
        ShortCode: ENV['MPESA_SHORTCODE'],
        ResponseType: "Completed",
        ConfirmationURL: "https://carboncube-ke.com/api/payments/confirm",
        ValidationURL: "https://carboncube-ke.com/api/payments/validate"
      }.to_json
    )

    if response.code == 200
      Rails.logger.info("✅ C2B URLs registered: #{response.body}")
      JSON.parse(response.body)
    else
      Rails.logger.error("❌ Failed to register C2B URLs: #{response.body}")
      nil
    end
  end
end
