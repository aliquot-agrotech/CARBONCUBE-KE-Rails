# app/models/purchaser.rb

class Purchaser < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :reviews
  has_many :cart_items
  has_many :bookmarks

  validates :username, presence: false, uniqueness: true
  validates :fullname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :location, presence: true

  attribute :cart_total_price, :decimal, default: 0
end
