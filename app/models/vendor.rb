# app/models/vendor.rb
class Vendor < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :categories
  has_many :ads
  has_many :order_vendors
  has_many :orders, through: :order_vendors
  has_many :reviews, through: :ads
  has_many :invoices, through: :orders
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :conversations
  has_many :notifications, as: :notifiable
  has_many :buy_for_me_order_vendors
  has_one :categories_vendor
  has_one :category, through: :categories_vendor
  has_one :vendor_tier
  has_one :tiers, through: :vendor_tier

  validates :fullname, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true
  validates :enterprise_name, presence: true
  validates :location, presence: true
  validates :business_registration_number, presence: true
  # validates :tier, inclusion: { in: %w[Free Basic Standard Premium] }

  def calculate_mean_rating
    reviews.average(:rating).to_f
  end

  def category_names
    categories.pluck(:name)
  end

  def check_and_block
    if calculate_mean_rating < 3.0
      update(blocked: true)
    else
      update(blocked: false)
    end
  end
end
