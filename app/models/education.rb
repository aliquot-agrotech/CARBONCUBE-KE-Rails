class Education < ApplicationRecord
  has_many :purchasers
  validates :level, presence: true, uniqueness: true
end
