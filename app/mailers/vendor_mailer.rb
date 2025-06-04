class VendorMailer < ApplicationMailer
  default from: ENV['BREVO_EMAIL']

  def document_expiry_reminder(vendor)
    @vendor = vendor
    mail(to: @vendor.email, subject: "Document Expiry Reminder")
  end

  def document_update_reminder(vendor)
    @vendor = vendor
    mail(to: @vendor.email, subject: "Please Update Your Expired Document")
  end
end
