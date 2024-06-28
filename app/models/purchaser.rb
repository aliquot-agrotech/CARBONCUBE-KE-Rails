class Purchaser < ApplicationRecord
    has_secure_password
  
    has_many :orders
    has_many :reviews
    has_one :vendor
  
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :role, inclusion: { in: %w[user vendor admin] }
    # Other validations...
  end