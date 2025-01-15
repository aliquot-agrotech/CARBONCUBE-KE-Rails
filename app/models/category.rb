class Category < ApplicationRecord
    has_and_belongs_to_many :vendors
    has_many :subcategories, dependent: :destroy
    has_many :ads, dependent: :nullify
    accepts_nested_attributes_for :subcategories

    validates :name, presence: true
end
