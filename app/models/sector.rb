class Sector < ApplicationRecord
  has_many :purchasers
  validates :name, presence: true, uniqueness: true
end
