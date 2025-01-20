class Education < ApplicationRecord
  validates :level, presence: true, uniqueness: true
end
