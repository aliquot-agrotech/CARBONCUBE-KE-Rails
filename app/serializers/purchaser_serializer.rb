# app/serializers/purchaser_serializer.rb
class PurchaserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :email, :phone_number, :location
end
