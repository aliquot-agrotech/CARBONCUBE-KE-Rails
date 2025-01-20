class Income < ApplicationRecord
  validates :range, presence: true, uniqueness: true
end
