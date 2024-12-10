# app/models/purchaser.rb

class Purchaser < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :reviews
  has_many :cart_items
  has_many :wish_lists, dependent: :destroy
  has_many :wish_listed_products, through: :wish_lists, source: :product
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :conversations
  has_many :notifications, as: :notifiable
  has_many :buy_for_me_orders


  validates :fullname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :phone_number, presence: true, length: { is: 10 }, format: { with: /\A\d{10}\z/ }
  validates :birthdate, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :gender, inclusion: { in: %w(Male Female Other) }
  validates :location, presence: true

  attribute :cart_total_price, :decimal, default: 0


  def wish_list_product(product)
    wish_lists.create(product: product) unless wish_listed?(product)
  end

  def unwish_list_product(product)
    wish_lists.find_by(product: product)&.destroy
  end

  def wish_listed?(product)
    wish_listed_products.include?(product)
  end

  def password_required?
    new_record? || password.present?
  end

end
