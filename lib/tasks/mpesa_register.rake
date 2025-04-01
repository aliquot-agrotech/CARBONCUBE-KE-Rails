namespace :mpesa do
  desc "Register M-Pesa Validation and Confirmation URLs"
  task register_urls: :environment do
    puts "Registering M-Pesa URLs..."
    puts MpesaApi.register_urls
  end
end
