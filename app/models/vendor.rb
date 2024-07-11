# app/models/vendor.rb
class Vendor < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :categories
  has_many :products
  has_many :order_vendors
  has_many :orders, through: :order_vendors
  has_many :reviews, through: :products
  has_many :invoices, through: :orders

  validates :fullname, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true
  validates :enterprise_name, presence: true
  validates :location, presence: true
  validates :business_registration_number, presence: true
end
