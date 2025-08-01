# app/models/seller.rb
class Seller < ApplicationRecord
  before_validation :normalize_email

  has_secure_password
  has_and_belongs_to_many :categories
  has_many :ads
  has_many :order_sellers
  has_many :orders, through: :order_sellers
  has_many :reviews, through: :ads
  has_many :invoices, through: :orders
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :conversations
  has_many :notifications, as: :notifiable
  has_many :buy_for_me_order_sellers
  has_many :password_otps, as: :otpable, dependent: :destroy
  has_one :categories_seller
  has_one :category, through: :categories_seller
  has_one :seller_tier
  has_one :tier, through: :seller_tier
  
  belongs_to :county
  belongs_to :sub_county
  belongs_to :age_group
  belongs_to :document_type, optional: true

  validates :county_id, presence: true
  validates :sub_county_id, presence: true
  validates :fullname, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :enterprise_name, presence: true
  validates :location, presence: true
  validates :business_registration_number, length: { minimum: 1 }, allow_blank: true
  validates :age_group, presence: true
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

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
