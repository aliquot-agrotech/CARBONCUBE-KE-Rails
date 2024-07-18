class VendorSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :phone_number, :email, :enterprise_name, :location, :business_registration_number, :description, :total_revenue, :total_orders, :customer_demographics, :analytics

  has_many :categories
end
