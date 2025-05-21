class SubCounty < ApplicationRecord
  belongs_to :county
  has_many :vendors
  # validates :name, presence: true
end
