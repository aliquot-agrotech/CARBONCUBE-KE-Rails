# app/mailers/otp_mailer.rb
class OtpMailer < ApplicationMailer
  def send_otp
    @email = params[:email]
    @code = params[:code]
    mail(to: @email, subject: 'Your OTP Code for CarbonCube-KE')
  end
end
