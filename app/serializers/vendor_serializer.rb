class VendorSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :phone_number, :email, :enterprise_name, :location, :business_registration_number, :description, :username, :profilepicture, :birthdate, :zipcode, :city, :gender, :blocked

  has_one :tier
  has_many :categories
end
