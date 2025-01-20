class Employment < ApplicationRecord
  validates :status, presence: true, uniqueness: true
end
