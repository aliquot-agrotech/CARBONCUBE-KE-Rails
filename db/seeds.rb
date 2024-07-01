# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# db/seeds.rb

# Create categories
categories = [
    { name: 'Filtration Solutions', description: 'Products related to filtration solutions' },
    { name: 'Hardware Tools', description: 'Various hardware tools' },
    { name: 'Automotive Spares', description: 'Spare parts for automobiles' },
    { name: 'Computer Parts and Accessories', description: 'Components and accessories for computers' }
]

categories.each do |category_data|
    Category.find_or_create_by(name: category_data[:name]) do |category|
        category.description = category_data[:description]
    end
end

# Seed admin data
Admin.find_or_create_by(email: 'admin@example.com') do |admin|
    admin.fullname = 'Admin Name'
    admin.password = 'adminpassword'
end

# Seed purchaser data
purchasers = [
    { fullname: 'Purchaser One', username: 'purchaser1', phone_number: '1234567890', email: 'purchaser1@example.com', location: '123 Street, City', password: 'password' },
    { fullname: 'Purchaser Two', username: 'purchaser2', phone_number: '1234567891', email: 'purchaser2@example.com', location: '456 Street, City', password: 'password' },
    { fullname: 'Purchaser Three', username: 'purchaser3', phone_number: '1234567892', email: 'purchaser3@example.com', location: '789 Street, City', password: 'password' }
]

purchasers.each do |purchaser_data|
    Purchaser.find_or_create_by(email: purchaser_data[:email]) do |purchaser|
        purchaser.fullname = purchaser_data[:fullname]
        purchaser.username = purchaser_data[:username]
        purchaser.phone_number = purchaser_data[:phone_number]
        purchaser.location = purchaser_data[:location]
        purchaser.password = purchaser_data[:password]
    end
end

# Seed vendor data
vendors = [
    { fullname: 'Vendor One', phone_number: '0987654321', email: 'vendor1@example.com', enterprise_name: 'Vendor One Enterprise', location: '321 Street, City', password: 'password', business_registration_number: 'BN/2024/123456', category_ids: [Category.first.id] },
    { fullname: 'Vendor Two', phone_number: '0987654322', email: 'vendor2@example.com', enterprise_name: 'Vendor Two Enterprise', location: '654 Street, City', password: 'password', business_registration_number: 'BN/2024/123457', category_ids: [Category.second.id] },
    { fullname: 'Vendor Three', phone_number: '0987654323', email: 'vendor3@example.com', enterprise_name: 'Vendor Three Enterprise', location: '987 Street, City', password: 'password', business_registration_number: 'BN/2024/123458', category_ids: [Category.third.id] }
]

vendors.each do |vendor_data|
    Vendor.find_or_create_by(email: vendor_data[:email]) do |vendor|
        vendor.fullname = vendor_data[:fullname]
        vendor.phone_number = vendor_data[:phone_number]
        vendor.enterprise_name = vendor_data[:enterprise_name]
        vendor.location = vendor_data[:location]
        vendor.password = vendor_data[:password]
        vendor.business_registration_number = vendor_data[:business_registration_number]
        vendor.category_ids = vendor_data[:category_ids]
    end
end

puts 'Seed data created successfully!'

