class VendorSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :phone_number, :email, :enterprise_name, :location, :business_registration_number, :description

  has_many :categories
end
