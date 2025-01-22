# app/serializers/purchaser_serializer.rb
class PurchaserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :email, :phone_number, :location, :username, :city, 
             :zipcode, :profile_picture, :birthdate, :gender, :blocked, 
             :income_id, :sector_id, :education_id, :employment_id
end
