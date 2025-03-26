namespace :mpesa do
  desc "Register M-Pesa Validation and Confirmation URLs"
  task register_urls: :environment do
    puts "Registering M-Pesa URLs..."
    puts MpesaAPI.register_urls
  end
end
