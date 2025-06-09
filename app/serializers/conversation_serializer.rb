class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :admin_id, :purchaser_id, :vendor_id, :ad_id, :created_at, :updated_at

  belongs_to :admin
  belongs_to :purchaser
  belongs_to :vendor
  belongs_to :ad
  # has_many :messages
end
