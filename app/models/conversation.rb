class Conversation < ApplicationRecord
  belongs_to :admin, class_name: 'Admin', foreign_key: 'admin_id', optional: true
  belongs_to :purchaser, class_name: 'Purchaser', foreign_key: 'purchaser_id', optional: true
  belongs_to :vendor, class_name: 'Vendor', foreign_key: 'vendor_id', optional: true
  belongs_to :ad, optional: true

  has_many :messages, dependent: :destroy

  # Validation for participant presence
  validate :at_least_one_participant_present
  validates :ad_id, uniqueness: { scope: [:purchaser_id, :vendor_id], message: "conversation already exists for this ad" }

  private

  def at_least_one_participant_present
    if admin_id.blank? && purchaser_id.blank? && vendor_id.blank?
      errors.add(:base, 'Conversation must have at least one participant (admin, purchaser, or vendor)')
    end
  end
end

