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
purchasers = [
  { fullname: 'John Doe', username: 'johndoe', phone_number: '1234567890', email: 'johndoe@example.com', location: '123 Main St, Anytown', password: 'password' },
  { fullname: 'Jane Smith', username: 'janesmith', phone_number: '1234567891', email: 'janesmith@example.com', location: '456 Oak St, Anytown', password: 'password' },
  { fullname: 'Alice Johnson', username: 'alicejohnson', phone_number: '1234567892', email: 'alicejohnson@example.com', location: '789 Maple St, Anytown', password: 'password' },
  { fullname: 'Bob Brown', username: 'bobbrown', phone_number: '1234567893', email: 'bobbrown@example.com', location: '101 Pine St, Anytown', password: 'password' },
  { fullname: 'Carol Davis', username: 'caroldavis', phone_number: '1234567894', email: 'caroldavis@example.com', location: '202 Cedar St, Anytown', password: 'password' },
  { fullname: 'David Evans', username: 'davidevans', phone_number: '1234567895', email: 'davidevans@example.com', location: '303 Birch St, Anytown', password: 'password' },
  { fullname: 'Eve Foster', username: 'evefoster', phone_number: '1234567896', email: 'evefoster@example.com', location: '404 Elm St, Anytown', password: 'password' },
  { fullname: 'Frank Green', username: 'frankgreen', phone_number: '1234567897', email: 'frankgreen@example.com', location: '505 Walnut St, Anytown', password: 'password' },
  { fullname: 'Grace Hill', username: 'gracehill', phone_number: '1234567898', email: 'gracehill@example.com', location: '606 Spruce St, Anytown', password: 'password' },
  { fullname: 'Hank Lee', username: 'hanklee', phone_number: '1234567899', email: 'hanklee@example.com', location: '707 Cherry St, Anytown', password: 'password' }
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
  { fullname: 'John Brown', phone_number: '0987654321', email: 'johnbrown@example.com', enterprise_name: 'Brown\'s Hardware', location: '123 Main St, Townsville', password: 'password', business_registration_number: 'BN/2021/123456', category_ids: [Category.first.id] },
  { fullname: 'Alice White', phone_number: '0987654322', email: 'alicewhite@example.com', enterprise_name: 'White\'s Automotive', location: '456 Oak St, Springfield', password: 'password', business_registration_number: 'BN/2024/123457', category_ids: [Category.second.id] },
  { fullname: 'Michael Johnson', phone_number: '0987654323', email: 'michaeljohnson@example.com', enterprise_name: 'Johnson\'s Electronics', location: '789 Elm St, Rivertown', password: 'password', business_registration_number: 'BN/2023/123458', category_ids: [Category.third.id] },
  { fullname: 'Emily Davis', phone_number: '0987654324', email: 'emilydavis@example.com', enterprise_name: 'Davis Construction', location: '101 Pine St, Lakeside', password: 'password', business_registration_number: 'BN/2024/123459', category_ids: [Category.fourth.id] },
  { fullname: 'Daniel Wilson', phone_number: '0987654325', email: 'danielwilson@example.com', enterprise_name: 'Wilson\'s Furniture', location: '202 Cedar St, Mountainview', password: 'password', business_registration_number: 'BN/2022/123460', category_ids: [Category.second.id] },
  { fullname: 'Sarah Martinez', phone_number: '0987654326', email: 'sarahmartinez@example.com', enterprise_name: 'Martinez Fashion', location: '303 Maple St, Seaside', password: 'password', business_registration_number: 'BN/2024/123461', category_ids: [Category.first.id] },
  { fullname: 'Kevin Rodriguez', phone_number: '0987654327', email: 'kevinrodriguez@example.com', enterprise_name: 'Rodriguez\'s Appliances', location: '404 Walnut St, Hilltop', password: 'password', business_registration_number: 'BN/2020/123462', category_ids: [Category.second.id] },
  { fullname: 'Jessica Garcia', phone_number: '0987654328', email: 'jessicagarcia@example.com', enterprise_name: 'Garcia\'s Jewelry', location: '505 Spruce St, Brookside', password: 'password', business_registration_number: 'BN/2024/123463', category_ids: [Category.third.id] },
  { fullname: 'David Lopez', phone_number: '0987654329', email: 'davidlopez@example.com', enterprise_name: 'Lopez\'s Bakery', location: '606 Pine St, Fairview', password: 'password', business_registration_number: 'BN/2020/123464', category_ids: [Category.fourth.id] },
  { fullname: 'Amanda Scott', phone_number: '0987654330', email: 'amandascott@example.com', enterprise_name: 'Scott\'s Sporting Goods', location: '707 Oak St, Sunnyside', password: 'password', business_registration_number: 'BN/2019/123465', category_ids: [Category.first.id] }
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

# Seed product data
products = [
  # Filtration Solutions
    { title: 'Advanced Water Filtration System', description: 'Provides clean and purified drinking water for households.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.first.id, price: 199.99, quantity: 50, brand: 'PureWater', manufacturer: 'WaterTech', package_length: 12, package_width: 6, package_height: 18, package_weight: 3.2 },
    { title: 'HEPA Air Purifier', description: 'Removes allergens and pollutants from the air, improving indoor air quality.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.second.id, price: 299.99, quantity: 30, brand: 'CleanAir', manufacturer: 'AirTech', package_length: 14, package_width: 8, package_height: 20, package_weight: 4.5 },
    { title: 'Oil Filter Kit', description: 'Complete oil filter replacement kit for various automotive models.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.third.id, price: 39.99, quantity: 100, brand: 'EngineGuard', manufacturer: 'AutoParts Inc', package_length: 10, package_width: 5, package_height: 15, package_weight: 2.0 },
    { title: 'Shower Water Filter', description: 'Filters chlorine and impurities from shower water, promoting healthier skin and hair.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.first.id, price: 49.99, quantity: 80, brand: 'PureShower', manufacturer: 'ShowerTech', package_length: 8, package_width: 4, package_height: 12, package_weight: 1.5 },
    { title: 'Under Sink Water Filter', description: 'Compact under sink water filtration system for clean drinking water.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.second.id, price: 149.99, quantity: 20, brand: 'PureSink', manufacturer: 'HomeTech', package_length: 16, package_width: 10, package_height: 14, package_weight: 3.0 },

    # Hardware Tools
    { title: 'Cordless Drill', description: 'Powerful cordless drill with multiple torque settings and LED light.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.third.id, price: 129.99, quantity: 40, brand: 'MaxDrill', manufacturer: 'ToolTech', package_length: 14, package_width: 6, package_height: 10, package_weight: 2.5 },
    { title: 'Tool Chest', description: 'Large tool chest with drawers and wheels for easy mobility.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.first.id, price: 299.99, quantity: 10, brand: 'ToolMaster', manufacturer: 'ToolCraft', package_length: 20, package_width: 12, package_height: 18, package_weight: 8.0 },
    { title: 'Hammer Set', description: 'Assorted hammer set with fiberglass handles for durability.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.second.id, price: 49.99, quantity: 50, brand: 'ProHammer', manufacturer: 'HammerTech', package_length: 8, package_width: 4, package_height: 12, package_weight: 1.8 },
    { title: 'Electric Screwdriver', description: 'Electric screwdriver with rechargeable battery and multiple bit attachments.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.third.id, price: 79.99, quantity: 30, brand: 'PowerDriver', manufacturer: 'DriverTech', package_length: 10, package_width: 5, package_height: 14, package_weight: 2.0 },
    { title: 'Heavy Duty Saw', description: 'Professional heavy-duty saw for woodworking and construction projects.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.first.id, price: 199.99, quantity: 20, brand: 'ProSaw', manufacturer: 'SawTech', package_length: 18, package_width: 8, package_height: 16, package_weight: 4.5 },

    # Automotive Spares
    { title: 'Brake Pad Kit', description: 'Complete brake pad replacement kit for cars and trucks.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.second.id, price: 79.99, quantity: 60, brand: 'BrakeTech', manufacturer: 'AutoParts Inc', package_length: 12, package_width: 6, package_height: 8, package_weight: 3.2 },
    { title: 'Car Alternator', description: 'High-output car alternator for improved electrical system performance.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.third.id, price: 149.99, quantity: 30, brand: 'PowerStart', manufacturer: 'AutoPower', package_length: 14, package_width: 7, package_height: 10, package_weight: 5.0 },
    { title: 'Engine Oil Filter', description: 'Premium engine oil filter for maintaining engine cleanliness.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.first.id, price: 19.99, quantity: 100, brand: 'FilterGuard', manufacturer: 'AutoFilters', package_length: 8, package_width: 4, package_height: 10, package_weight: 1.5 },
    { title: 'Tire Pressure Gauge', description: 'Digital tire pressure gauge with LCD display for accurate readings.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.second.id, price: 29.99, quantity: 150, brand: 'PressureMaster', manufacturer: 'AutoGauge', package_length: 6, package_width: 3, package_height: 1, package_weight: 0.5 },
    { title: 'Automotive Battery', description: 'Long-lasting automotive battery with high cold-cranking amps.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.third.id, price: 99.99, quantity: 50, brand: 'PowerPlus', manufacturer: 'AutoPower', package_length: 10, package_width: 6, package_height: 8, package_weight: 4.0 },

    # Computer Parts and Accessories
    { title: 'Wireless Keyboard', description: 'Slim wireless keyboard with whisper-quiet keys for comfortable typing.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.first.id, price: 49.99, quantity: 100, brand: 'TechKeys', manufacturer: 'TechGear', package_length: 12, package_width: 5, package_height: 2, package_weight: 1.0 },
    { title: 'Gaming Mouse', description: 'High-precision gaming mouse with customizable RGB lighting.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.second.id, price: 69.99, quantity: 80, brand: 'GamerTech', manufacturer: 'TechGear', package_length: 8, package_width: 4, package_height: 2, package_weight: 0.8 },
    { title: 'CPU Cooler', description: 'Efficient CPU cooler with heat pipes and quiet fan operation.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.third.id, price: 39.99, quantity: 120, brand: 'CoolMaster', manufacturer: 'TechCooling', package_length: 14, package_width: 6, package_height: 4, package_weight: 0.7 },
    { title: 'Graphics Card', description: 'High-performance graphics card for smooth gaming and multimedia.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.first.id, price: 299.99, quantity: 30, brand: 'PowerGFX', manufacturer: 'TechGraphics', package_length: 10, package_width: 5, package_height: 2, package_weight: 1.2 },
    { title: 'Solid State Drive (SSD)', description: 'Fast SSD storage drive for quick boot-up and file access.', media: ['image1.jpg', 'image2.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.second.id, price: 129.99, quantity: 50, brand: 'TurboDrive', manufacturer: 'TechStorage', package_length: 8, package_width: 4, package_height: 1, package_weight: 0.5 },
]

products.each do |product_data|
    Product.find_or_create_by(title: product_data[:title]) do |product|
        product.description = product_data[:description]
        product.media = product_data[:media]
        product.category_id = product_data[:category_id]
        product.vendor_id = product_data[:vendor_id]
        product.price = product_data[:price]
        product.quantity = product_data[:quantity]
        product.brand = product_data[:brand]
        product.manufacturer = product_data[:manufacturer]
        product.package_length = product_data[:package_length]
        product.package_width = product_data[:package_width]
        product.package_height = product_data[:package_height]
        product.package_weight = product_data[:package_weight]
    end
end

# Seed orders data
orders = [
  { purchaser_id: Purchaser.first.id, status: 'processing', total_amount: 129.98, mpesa_transaction_code: 'SGA96AZWUR' },
  { purchaser_id: Purchaser.second.id, status: 'processing', total_amount: 219.98, mpesa_transaction_code: 'TGB78HYUJ9' },
  { purchaser_id: Purchaser.third.id, status: 'processing', total_amount: 89.99, mpesa_transaction_code: 'HJK89JNHU1' },
  { purchaser_id: Purchaser.first.id, status: 'processing', total_amount: 189.98, mpesa_transaction_code: 'YUIO90JIKL' },
  { purchaser_id: Purchaser.second.id, status: 'processing', total_amount: 299.99, mpesa_transaction_code: 'KJH45RTFG7' },
  { purchaser_id: Purchaser.third.id, status: 'processing', total_amount: 59.99, mpesa_transaction_code: 'LMN12VBNM6' },
  { purchaser_id: Purchaser.first.id, status: 'processing', total_amount: 159.98, mpesa_transaction_code: 'ZXC34FGHJ8' },
  { purchaser_id: Purchaser.second.id, status: 'processing', total_amount: 209.97, mpesa_transaction_code: 'QWE56RTYU7' },
  { purchaser_id: Purchaser.third.id, status: 'processing', total_amount: 119.98, mpesa_transaction_code: 'RTY67YUIO0' },
  { purchaser_id: Purchaser.first.id, status: 'processing', total_amount: 179.97, mpesa_transaction_code: 'BNM45FGHJ9' }
]

orders.each do |order_data|
  Order.create!(order_data)
end


# Ensure orders and products are created before running this

# Fetch all orders and products
orders = Order.all
products = Product.all
vendors = Vendor.all

# Assuming you have already loaded products and orders
order_items = [
  { order_id: orders[0].id, product_id: products[0].id, quantity: 2 },
  { order_id: orders[0].id, product_id: products[1].id, quantity: 1 },
  { order_id: orders[1].id, product_id: products[2].id, quantity: 3 },
  { order_id: orders[1].id, product_id: products[13].id, quantity: 2 },
  { order_id: orders[2].id, product_id: products[4].id, quantity: 1 },
  { order_id: orders[2].id, product_id: products[0].id, quantity: 2 },
  { order_id: orders[3].id, product_id: products[12].id, quantity: 1 },
  { order_id: orders[3].id, product_id: products[2].id, quantity: 2 },
  { order_id: orders[4].id, product_id: products[4].id, quantity: 1 },
  { order_id: orders[4].id, product_id: products[15].id, quantity: 3 },
  { order_id: orders[5].id, product_id: products[3].id, quantity: 2 },
  { order_id: orders[5].id, product_id: products[0].id, quantity: 1 },
  { order_id: orders[6].id, product_id: products[2].id, quantity: 4 },
  { order_id: orders[6].id, product_id: products[1].id, quantity: 2 },
  { order_id: orders[7].id, product_id: products[3].id, quantity: 1 },
  { order_id: orders[7].id, product_id: products[4].id, quantity: 3 },
  { order_id: orders[8].id, product_id: products[17].id, quantity: 2 },
  { order_id: orders[8].id, product_id: products[2].id, quantity: 1 },
  { order_id: orders[9].id, product_id: products[3].id, quantity: 3 },
  { order_id: orders[9].id, product_id: products[1].id, quantity: 2 }
]

order_items.each do |order_item_data|
  order_item_data[:price] = Product.find(order_item_data[:product_id]).price
  order_item_data[:total_price] = order_item_data[:price] * order_item_data[:quantity]
  OrderItem.create!(order_item_data)
end


# Seed order vendors data
order_vendors = [
  { order_id: orders[0].id, vendor_id: vendors[0].id },
  { order_id: orders[1].id, vendor_id: vendors[1].id },
  { order_id: orders[2].id, vendor_id: vendors[2].id },
  { order_id: orders[3].id, vendor_id: vendors[1].id },
  { order_id: orders[4].id, vendor_id: vendors[2].id },
  { order_id: orders[5].id, vendor_id: vendors[0].id },
  { order_id: orders[6].id, vendor_id: vendors[2].id },
  { order_id: orders[7].id, vendor_id: vendors[0].id },
  { order_id: orders[8].id, vendor_id: vendors[1].id },
  { order_id: orders[9].id, vendor_id: vendors[1].id }
]

order_vendors.each do |order_vendor_data|
  OrderVendor.create!(order_vendor_data)
end

reviews_data = [
  { product_id: 1, purchaser_id: 1, rating: 5, review: "Excellent product, highly recommend!" },
  { product_id: 2, purchaser_id: 2, rating: 4, review: "Good value for money." },
  { product_id: 3, purchaser_id: 3, rating: 3, review: "Average quality, expected better." },
  { product_id: 4, purchaser_id: 4, rating: 5, review: "Superb! Exactly what I needed." },
  { product_id: 5, purchaser_id: 5, rating: 2, review: "Not satisfied with the product." },
  { product_id: 1, purchaser_id: 2, rating: 4, review: "Pretty good, works as expected." },
  { product_id: 2, purchaser_id: 3, rating: 5, review: "Fantastic, exceeded my expectations!" },
  { product_id: 3, purchaser_id: 4, rating: 1, review: "Poor quality, would not buy again." },
  { product_id: 4, purchaser_id: 5, rating: 3, review: "It's okay, not great." },
  { product_id: 5, purchaser_id: 1, rating: 4, review: "Good product, worth the price." }
]

reviews_data.each do |review_data|
  Review.create!(review_data)
end


# Clear existing records
Faq.delete_all

# Create FAQs
Faq.create!(
  [
    { question: 'What is the return policy?', answer: 'You can return items within 30 days of purchase for a full refund.' },
    { question: 'How can I track my order?', answer: 'You will receive a tracking number via email once your order has shipped.' },
    { question: 'Do you offer international shipping?', answer: 'Yes, we ship internationally. Shipping costs will be calculated at checkout.' },
    { question: 'Can I change or cancel my order?', answer: 'Orders can be modified or canceled within 1 hour of placing them.' },
    { question: 'What payment methods are accepted?', answer: 'We accept Visa, MasterCard, American Express, and PayPal.' },
    { question: 'How do I contact customer service?', answer: 'You can reach our customer service team by emailing support@example.com.' },
    { question: 'Is my personal information safe?', answer: 'Yes, we use SSL encryption to protect your personal information.' },
    { question: 'Do you offer gift cards?', answer: 'Yes, gift cards are available for purchase on our website.' },
    { question: 'How can I return a defective item?', answer: 'Please contact our customer service team for instructions on returning defective items.' },
    { question: 'What is your warranty policy?', answer: 'We offer a one-year warranty on all products. Please keep your receipt for warranty claims.' }
  ]
)

# Clear existing records
About.delete_all

# Create About entry
About.create!(
  description: 'We are a leading provider of high-quality products designed to improve your life. Our mission is to deliver exceptional value through innovative solutions and outstanding customer service.',
  mission: 'To provide our customers with the best products and services that meet their needs and exceed their expectations.',
  vision: 'To be the most trusted and preferred brand in our industry, known for our commitment to quality and customer satisfaction.',
  values: ['Integrity', 'Innovation', 'Customer Focus', 'Excellence', 'Sustainability'],
  why_choose_us: 'Our products are crafted with precision and care, ensuring top-notch quality and performance. We prioritize customer satisfaction and continuously strive to exceed expectations.',
  image_url: 'https://example.com/images/about-us.jpg'
)

# db/seeds.rb

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

# Generate some detailed messages for each conversation
def create_messages(conversation, sender, receiver)
  # Example messages with more detail
  messages = [
    { sender: sender, content: 'Hello, how can I assist you today?' },
    { sender: receiver, content: 'I need help with updating my product listings.' },
    { sender: sender, content: 'Sure, I can help with that. Could you provide more details about the products you want to update?' },
    { sender: receiver, content: 'I have a few new products that need to be added, and some existing products need their prices updated.' },
    { sender: sender, content: 'Got it. Please send me the details of the new products and the changes you need for the existing ones.' },
    { sender: receiver, content: 'I’ve attached a document with the product details. Let me know if you need anything else.' },
    { sender: sender, content: 'Thanks for the document. I’ll review it and get back to you shortly.' },
    { sender: sender, content: 'I have reviewed the document. All updates have been made. Is there anything else you need help with?' },
    { sender: receiver, content: 'No, that’s all for now. Thank you for your assistance!' },
    { sender: sender, content: 'You’re welcome! If you have any more questions in the future, feel free to reach out.' }
  ]

  messages.each do |message_data|
    Message.create!(
      conversation: conversation,
      sender: message_data[:sender],
      content: message_data[:content]
    )
  end
end

# Generate messages for each conversation with detailed scenarios
Conversation.all.each do |conversation|
  if conversation.purchaser_id.present?
    create_messages(conversation, admin, Purchaser.find(conversation.purchaser_id))
  elsif conversation.vendor_id.present?
    create_messages(conversation, admin, Vendor.find(conversation.vendor_id))
  end
end

# Example of additional conversations with varied scenarios

# Create additional specific conversations
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



puts 'Seed data created successfully!'

