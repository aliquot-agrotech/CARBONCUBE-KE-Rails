class Rider < ApplicationRecord
  has_secure_password

  # Validations
  validates :full_name, :phone_number, :email, :id_number, :driving_license, :physical_address, :vehicle_type, :license_plate, :next_of_kin_full_name, :relationship, :emergency_contact_phone_number, presence: true
  validates :phone_number, uniqueness: true
  validates :email, uniqueness: true
end
