class Category < ApplicationRecord
    has_and_belongs_to_many :vendors
    has_many :subcategories, dependent: :destroy
    has_many :products, dependent: :nullify

    validates :name, presence: true
end
