class AgeGroup < ApplicationRecord
  has_many :purchasers

  validates :name, presence: true, uniqueness: true
end
