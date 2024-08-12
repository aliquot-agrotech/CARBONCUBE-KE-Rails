class Admin < ApplicationRecord
    has_many :sent_messages, as: :sender, class_name: 'Message'
    has_many :conversations
    has_many :notifications, as: :notifiable
    
    validates :username, presence: true
    validates :fullname, presence: true
    validates :email, presence: true, uniqueness: true

    has_secure_password
end
