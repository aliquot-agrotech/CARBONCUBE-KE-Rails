class Tier < ApplicationRecord
  has_many :tier_features, dependent: :destroy
  has_many :tier_pricings, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :ads_limit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
