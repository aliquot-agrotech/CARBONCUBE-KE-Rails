class Employment < ApplicationRecord
  has_many :purchasers
  validates :status, presence: true, uniqueness: true
end
