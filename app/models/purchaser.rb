class Purchaser < ApplicationRecord
    has_secure_password
  
    has_many :orders
    has_many :reviews
    has_one :vendor
  
    validates :username, presence: false, uniqueness: true
    validates :fullname, presence: true
    validates :email, presence: true, uniqueness: true
    validates :phone_number, presence: true
    validates :location, presence: true

    # Other validations...
  end