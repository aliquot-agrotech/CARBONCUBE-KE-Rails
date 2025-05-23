class AgeGroup < ApplicationRecord
  has_many :purchasers
  has_many :vendors

  validates :name, presence: true, uniqueness: true
end
