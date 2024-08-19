# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# db/seeds.rb

# db/seeds.rb

require 'faker'
require 'set'
# Create categories with descriptions
categories = [
    { name: 'Filtration Solutions', description: 'Products related to filtration solutions' },
    { name: 'Hardware Tools & Equipment', description: 'Various Hardware Tools' },
    { name: 'Automotive Parts & Accessories', description: 'Spare parts for automobiles' },
    { name: 'Computer Parts & Accessories', description: 'Components and accessories for computers' }
]

# Create or find categories and add subcategories
categories.each do |category_data|
  category = Category.find_or_create_by(name: category_data[:name]) do |c|
    c.description = category_data[:description]
  end

  # Add subcategories based on category name
  case category.name
  when 'Automotive Parts & Accessories'
    category.subcategories.find_or_create_by([
      { name: 'Batteries' },
      { name: 'Lubrication' },
      { name: 'Mechanical Tools' },
      { name: 'Spare Parts' },
      { name: 'Tyres' }
    ])
  when 'Computer Parts & Accessories'
    category.subcategories.find_or_create_by([
      { name: 'Cooling & Maintenance' },
      { name: 'Internal Components' },
      { name: 'Networking Equipment' },
      { name: 'Peripherals' },
      { name: 'Storage Solutions' }
    ])
  when 'Filtration Solutions'
    category.subcategories.find_or_create_by([
      { name: 'Air Filters' },
      { name: 'Fuel Filters' },
      { name: 'Industrial Ventilation Filters' },
      { name: 'Oil & Hydraulic Filters' },
      { name: 'Specialised Filtration Solutions' }
    ])
  when 'Hardware Tools & Equipment'
    category.subcategories.find_or_create_by([
      { name: 'Building Materials' },
      { name: 'Cleaning Supplies' },
      { name: 'Hand & Power Tools' },
      { name: 'Power & Electrical Equipment' },
      { name: 'Plumbing Supplies' }
    ])
  end
end


# Seed admin data
Admin.find_or_create_by(email: 'admin@example.com') do |admin|
  admin.fullname = 'Admin Name'
  admin.username = 'admin'
  admin.password = 'adminpassword'
end

# Set to keep track of used phone numbers
used_phone_numbers = Set.new

# Method to generate a unique phone number
def generate_custom_phone_number(used_phone_numbers)
  loop do
    phone_number = "07#{Faker::Number.number(digits: 8)}"
    return phone_number unless used_phone_numbers.include?(phone_number)
  end
end

# Seed purchasers data
100.times do
  Purchaser.find_or_create_by(email: Faker::Internet.unique.email) do |purchaser|
    purchaser.fullname = Faker::Name.name
    purchaser.username = Faker::Internet.username
    purchaser.phone_number = generate_custom_phone_number(used_phone_numbers)
    used_phone_numbers.add(purchaser.phone_number)
    purchaser.location = Faker::Address.full_address
    purchaser.password = 'password'
  end
end

# Seed vendors data
100.times do
  Vendor.find_or_create_by(email: Faker::Internet.unique.email) do |vendor|
    vendor.fullname = Faker::Name.name
    vendor.phone_number = generate_custom_phone_number(used_phone_numbers)
    used_phone_numbers.add(vendor.phone_number)
    vendor.enterprise_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    vendor.location = Faker::Address.full_address
    vendor.password = 'password'
    vendor.business_registration_number = "BN/#{Faker::Number.number(digits: 4)}/#{Faker::Number.number(digits: 6)}"
    vendor.category_ids = [Category.all.sample.id]
  end
end


# Seed products data
# Find the category and subcategory
automotive_category = Category.find_by(name: 'Automotive Parts & Accessories')
batteries_subcategory = automotive_category.subcategories.find_by(name: 'Batteries')

# Seed 50 products for the "Batteries" subcategory
50.times do
  Product.create(
    title: Faker::Vehicle.battery,  # Generates random battery names
    description: 'High-quality automotive battery suitable for a range of vehicles.',
    category_id: automotive_category.id,
    subcategory_id: batteries_subcategory.id,
    vendor_id: Vendor.all.sample.id,
    price: Faker::Commerce.price(range: 200..1000),
    quantity: Faker::Number.between(from: 30, to: 100),
    brand: Faker::Company.name,
    manufacturer: Faker::Company.name,
    package_length: Faker::Number.between(from: 10, to: 50),
    package_width: Faker::Number.between(from: 10, to: 50),
    package_height: Faker::Number.between(from: 10, to: 50),
    package_weight: Faker::Number.decimal(l_digits: 1, r_digits: 2),
    media: [Faker::LoremFlickr.image, Faker::LoremFlickr.image]
  )
end


# Find the category and subcategory
automotive_category = Category.find_by(name: 'Automotive Parts & Accessories')
lubrication_subcategory = automotive_category.subcategories.find_by(name: 'Lubrication')

# Seed 50 products for the "Lubrication" subcategory
50.times do
  Product.create(
    title: Faker::Vehicle.make_and_model + ' Lubricant',  # Generates random lubricant names
    description: 'High-performance lubricant suitable for automotive engines and machinery.',
    category_id: automotive_category.id,
    subcategory_id: lubrication_subcategory.id,
    vendor_id: Vendor.all.sample.id,
    price: Faker::Commerce.price(range: 50..500),
    quantity: Faker::Number.between(from: 30, to: 100),
    brand: Faker::Company.name,
    manufacturer: Faker::Company.name,
    package_length: Faker::Number.between(from: 10, to: 50),
    package_width: Faker::Number.between(from: 10, to: 50),
    package_height: Faker::Number.between(from: 10, to: 50),
    package_weight: Faker::Number.decimal(l_digits: 1, r_digits: 2),
    media: [Faker::LoremFlickr.image, Faker::LoremFlickr.image]
  )
end




# Generate 500 orders
500.times do
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

# Generate 10 reviews for each product
Product.all.each do |product|
  10.times do
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
  20.times do |i|
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
20.times do
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

