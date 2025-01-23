class Income < ApplicationRecord

  has_many :purchasers
  validates :range, presence: true, uniqueness: true
end
