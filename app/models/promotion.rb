class Promotion < ApplicationRecord
  belongs_to :vendor
  
  validates :title, presence: true
  validates :description, presence: true
  validates :discount_percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
