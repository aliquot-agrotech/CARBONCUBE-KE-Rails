class Admin < ApplicationRecord
    has_secure_password


    validates :fullname, presence: true
    validates :email, presence: true, uniqueness: true
end
