class Conversation < ApplicationRecord
  belongs_to :admin, class_name: 'Admin', foreign_key: 'admin_id', optional: true
  belongs_to :purchaser, class_name: 'Purchaser', foreign_key: 'purchaser_id', optional: true
  belongs_to :vendor, class_name: 'Vendor', foreign_key: 'vendor_id', optional: true
  belongs_to :ad, optional: true

  has_many :messages, dependent: :destroy

  validates :admin_id, presence: true
  validate :only_one_participant
  validates :ad_id, uniqueness: { scope: [:purchaser_id, :vendor_id], message: "conversation already exists for this ad" }

  private

  def only_one_participant
    if purchaser_id.present? && vendor_id.present?
      errors.add(:base, 'Conversation can only have one participant: either purchaser or vendor')
    elsif purchaser_id.blank? && vendor_id.blank?
      errors.add(:base, 'Conversation must have either a purchaser or a vendor')
    end
  end
end
