# app/models/purchaser.rb

class Purchaser < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :reviews
  has_many :cart_items
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_products, through: :bookmarks, source: :product
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :conversations
  has_many :notifications, as: :notifiable


  validates :username, presence: false, uniqueness: true
  validates :fullname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :location, presence: true
  attribute :cart_total_price, :decimal, default: 0


  def bookmark_product(product)
    bookmarks.create(product: product) unless bookmarked?(product)
  end

  def unbookmark_product(product)
    bookmarks.find_by(product: product)&.destroy
  end

  def bookmarked?(product)
    bookmarked_products.include?(product)
  end
end
