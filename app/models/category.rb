class Category < ApplicationRecord
    has_and_belongs_to_many :vendors
    has_many :products

    validates :name, presence: true
end
