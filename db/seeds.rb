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

require 'faker'

# Create categories
categories = [
    { name: 'Filtration Solutions', description: 'Products related to filtration solutions' },
    { name: 'Hardware Tools', description: 'Various Hardware Tools' },
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
  admin.username = 'admin'
  admin.password = 'adminpassword'
end

# Seed purchaser data
50.times do
  Purchaser.find_or_create_by(email: Faker::Internet.unique.email) do |purchaser|
    purchaser.fullname = Faker::Name.name
    purchaser.username = Faker::Internet.username
    purchaser.phone_number = Faker::PhoneNumber.cell_phone
    purchaser.location = Faker::Address.full_address
    purchaser.password = 'password'
  end
end

# Seed vendor data
50.times do
  Vendor.find_or_create_by(email: Faker::Internet.unique.email) do |vendor|
    vendor.fullname = Faker::Name.name
    vendor.phone_number = Faker::PhoneNumber.cell_phone
    vendor.enterprise_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    vendor.location = Faker::Address.full_address
    vendor.password = 'password'
    vendor.business_registration_number = "BN/#{Faker::Number.number(digits: 4)}/#{Faker::Number.number(digits: 6)}"
    vendor.category_ids = [Category.all.sample.id]
  end
end

# Seed product data
1000.times do
  Product.find_or_create_by(title: Faker::Commerce.product_name) do |product|
    product.description = Faker::Commerce.material
    product.media = [Faker::LoremFlickr.image, Faker::LoremFlickr.image]
    product.category_id = Category.all.sample.id
    product.vendor_id = Vendor.all.sample.id
    product.price = Faker::Commerce.price(range: 10..1000)
    product.quantity = Faker::Number.between(from: 1, to: 100)
    product.brand = Faker::Company.name
    product.manufacturer = Faker::Company.name
    product.package_length = Faker::Number.between(from: 10, to: 50)
    product.package_width = Faker::Number.between(from: 10, to: 50)
    product.package_height = Faker::Number.between(from: 10, to: 50)
    product.package_weight = Faker::Number.decimal(l_digits: 1, r_digits: 2)
  end
end


# Generate 300 orders
300.times do
  purchaser = Purchaser.all.sample
  status = ['processing', 'on-transit', 'delivered'].sample
  total_amount = Faker::Commerce.price(range: 50..500)
  mpesa_transaction_code = Faker::Alphanumeric.unique.alpha(number: 10).upcase

  order = Order.create!(
    purchaser_id: purchaser.id,
    status: status,
    total_amount: total_amount,
    mpesa_transaction_code: mpesa_transaction_code
  )

  # For each order, create between 1 to 5 order items
  rand(1..5).times do
    product = Product.all.sample
    quantity = Faker::Number.between(from: 1, to: 10)
    price = product.price
    total_price = price * quantity

    OrderItem.create!(
      order_id: order.id,
      product_id: product.id,
      quantity: quantity,
      price: price,
      total_price: total_price
    )

    # Associate the order with a vendor
    OrderVendor.create!(
      order_id: order.id,
      vendor_id: product.vendor_id
    )
  end
end

# Generate 5 reviews for each product
Product.all.each do |product|
  5.times do
    purchaser = Purchaser.all.sample
    rating = Faker::Number.between(from: 1, to: 5)
    review_text = Faker::Lorem.sentence(word_count: Faker::Number.between(from: 5, to: 15))

    Review.create!(
      product_id: product.id,
      purchaser_id: purchaser.id,
      rating: rating,
      review: review_text
    )
  end
end


# Clear existing records
Faq.delete_all

# Create FAQs
100.times do
  Faq.create!(
    question: Faker::Lorem.sentence(word_count: 6),
    answer: Faker::Lorem.paragraph(sentence_count: 2)
  )
end


# Clear existing records
About.delete_all

# Create About entry with Faker data
About.create!(
  description: Faker::Lorem.paragraph(sentence_count: 3),
  mission: Faker::Lorem.sentence(word_count: 12),
  vision: Faker::Lorem.sentence(word_count: 12),
  values: Faker::Lorem.words(number: 5),  # Random list of 5 words
  why_choose_us: Faker::Lorem.paragraph(sentence_count: 2),
  image_url: Faker::LoremFlickr.image(size: "600x400", search_terms: ['business'])
)

# Seed data for Conversations
admin = Admin.find_by(email: 'admin@example.com')
purchasers = Purchaser.all
vendors = Vendor.all

# Ensure there is an admin present
raise 'Admin not found' unless admin

# Create conversations between admin and each purchaser
purchasers.each do |purchaser|
  Conversation.find_or_create_by!(admin_id: admin.id, purchaser_id: purchaser.id) do |conversation|
    conversation.save!
  end
end

# Create conversations between admin and each vendor
vendors.each do |vendor|
  Conversation.find_or_create_by!(admin_id: admin.id, vendor_id: vendor.id) do |conversation|
    conversation.save!
  end
end

# Generate unique messages for each conversation
def create_messages(conversation, sender, receiver)
  10.times do |i|
    Message.create!(
      conversation: conversation,
      sender: sender,
      content: Faker::Lorem.sentence(word_count: 10 + i)
    )
    Message.create!(
      conversation: conversation,
      sender: receiver,
      content: Faker::Lorem.sentence(word_count: 10 + i)
    )
  end
end

# Generate messages for each conversation with unique content
Conversation.all.each do |conversation|
  if conversation.purchaser_id.present?
    create_messages(conversation, admin, Purchaser.find(conversation.purchaser_id))
  elsif conversation.vendor_id.present?
    create_messages(conversation, admin, Vendor.find(conversation.vendor_id))
  end
end

# Example of additional conversations with varied scenarios
additional_conversations = [
  { admin_id: admin.id, purchaser_id: purchasers.first.id },
  { admin_id: admin.id, vendor_id: vendors.first.id }
]

additional_conversations.each do |conv_data|
  conversation = Conversation.find_or_create_by!(conv_data)
  
  if conversation.purchaser_id.present?
    create_messages(conversation, admin, Purchaser.find(conversation.purchaser_id))
  elsif conversation.vendor_id.present?
    create_messages(conversation, admin, Vendor.find(conversation.vendor_id))
  end
end


# Function to generate a random coupon code with the discount percentage
def generate_coupon_code(discount_percentage)
  random_string = Faker::Alphanumeric.alpha(number: 4).upcase
  "#{random_string}#{discount_percentage.to_s.rjust(2, '0')}"
end

# Create 10 promotions with random data
10.times do
  discount_percentage = rand(1..14)  # Random percentage between 1 and 100
  Promotion.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    discount_percentage: discount_percentage,
    coupon_code: generate_coupon_code(discount_percentage),
    start_date: Faker::Date.backward(days: 0),
    end_date: Faker::Date.forward(days: rand(10..20))
  )
end


puts 'Congratulations!! Seed data created successfully!'

