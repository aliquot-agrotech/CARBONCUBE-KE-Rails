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

# Seed product data
products = [
  # Filtration Solutions
    { title: 'Advanced Water Filtration System', description: 'Provides clean and purified drinking water for households.', media: ['water_filter.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.first.id, price: 199.99, quantity: 50, brand: 'PureWater', manufacturer: 'WaterTech', package_length: 12, package_width: 6, package_height: 18, package_weight: 3.2 },
    { title: 'HEPA Air Purifier', description: 'Removes allergens and pollutants from the air, improving indoor air quality.', media: ['air_purifier.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.second.id, price: 299.99, quantity: 30, brand: 'CleanAir', manufacturer: 'AirTech', package_length: 14, package_width: 8, package_height: 20, package_weight: 4.5 },
    { title: 'Oil Filter Kit', description: 'Complete oil filter replacement kit for various automotive models.', media: ['oil_filter.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.third.id, price: 39.99, quantity: 100, brand: 'EngineGuard', manufacturer: 'AutoParts Inc', package_length: 10, package_width: 5, package_height: 15, package_weight: 2.0 },
    { title: 'Shower Water Filter', description: 'Filters chlorine and impurities from shower water, promoting healthier skin and hair.', media: ['shower_filter.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.first.id, price: 49.99, quantity: 80, brand: 'PureShower', manufacturer: 'ShowerTech', package_length: 8, package_width: 4, package_height: 12, package_weight: 1.5 },
    { title: 'Under Sink Water Filter', description: 'Compact under sink water filtration system for clean drinking water.', media: ['under_sink_filter.jpg'], category_id: Category.find_by(name: 'Filtration Solutions').id, vendor_id: Vendor.second.id, price: 149.99, quantity: 20, brand: 'PureSink', manufacturer: 'HomeTech', package_length: 16, package_width: 10, package_height: 14, package_weight: 3.0 },

    # Hardware Tools
    { title: 'Cordless Drill', description: 'Powerful cordless drill with multiple torque settings and LED light.', media: ['cordless_drill.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.third.id, price: 129.99, quantity: 40, brand: 'MaxDrill', manufacturer: 'ToolTech', package_length: 14, package_width: 6, package_height: 10, package_weight: 2.5 },
    { title: 'Tool Chest', description: 'Large tool chest with drawers and wheels for easy mobility.', media: ['tool_chest.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.first.id, price: 299.99, quantity: 10, brand: 'ToolMaster', manufacturer: 'ToolCraft', package_length: 20, package_width: 12, package_height: 18, package_weight: 8.0 },
    { title: 'Hammer Set', description: 'Assorted hammer set with fiberglass handles for durability.', media: ['hammer_set.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.second.id, price: 49.99, quantity: 50, brand: 'ProHammer', manufacturer: 'HammerTech', package_length: 8, package_width: 4, package_height: 12, package_weight: 1.8 },
    { title: 'Electric Screwdriver', description: 'Electric screwdriver with rechargeable battery and multiple bit attachments.', media: ['electric_screwdriver.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.third.id, price: 79.99, quantity: 30, brand: 'PowerDriver', manufacturer: 'DriverTech', package_length: 10, package_width: 5, package_height: 14, package_weight: 2.0 },
    { title: 'Heavy Duty Saw', description: 'Professional heavy-duty saw for woodworking and construction projects.', media: ['heavy_duty_saw.jpg'], category_id: Category.find_by(name: 'Hardware Tools').id, vendor_id: Vendor.first.id, price: 199.99, quantity: 20, brand: 'ProSaw', manufacturer: 'SawTech', package_length: 18, package_width: 8, package_height: 16, package_weight: 4.5 },

    # Automotive Spares
    { title: 'Brake Pad Kit', description: 'Complete brake pad replacement kit for cars and trucks.', media: ['brake_pad_kit.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.second.id, price: 79.99, quantity: 60, brand: 'BrakeTech', manufacturer: 'AutoParts Inc', package_length: 12, package_width: 6, package_height: 8, package_weight: 3.2 },
    { title: 'Car Alternator', description: 'High-output car alternator for improved electrical system performance.', media: ['car_alternator.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.third.id, price: 149.99, quantity: 30, brand: 'PowerStart', manufacturer: 'AutoPower', package_length: 14, package_width: 7, package_height: 10, package_weight: 5.0 },
    { title: 'Engine Oil Filter', description: 'Premium engine oil filter for maintaining engine cleanliness.', media: ['engine_oil_filter.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.first.id, price: 19.99, quantity: 100, brand: 'FilterGuard', manufacturer: 'AutoFilters', package_length: 8, package_width: 4, package_height: 10, package_weight: 1.5 },
    { title: 'Tire Pressure Gauge', description: 'Digital tire pressure gauge with LCD display for accurate readings.', media: ['tire_pressure_gauge.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.second.id, price: 29.99, quantity: 150, brand: 'PressureMaster', manufacturer: 'AutoGauge', package_length: 6, package_width: 3, package_height: 1, package_weight: 0.5 },
    { title: 'Automotive Battery', description: 'Long-lasting automotive battery with high cold-cranking amps.', media: ['automotive_battery.jpg'], category_id: Category.find_by(name: 'Automotive Spares').id, vendor_id: Vendor.third.id, price: 99.99, quantity: 50, brand: 'PowerPlus', manufacturer: 'AutoPower', package_length: 10, package_width: 6, package_height: 8, package_weight: 4.0 },

    # Computer Parts and Accessories
    { title: 'Wireless Keyboard', description: 'Slim wireless keyboard with whisper-quiet keys for comfortable typing.', media: ['wireless_keyboard.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.first.id, price: 49.99, quantity: 100, brand: 'TechKeys', manufacturer: 'TechGear', package_length: 12, package_width: 5, package_height: 2, package_weight: 1.0 },
    { title: 'Gaming Mouse', description: 'High-precision gaming mouse with customizable RGB lighting.', media: ['gaming_mouse.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.second.id, price: 69.99, quantity: 80, brand: 'GamerTech', manufacturer: 'TechGear', package_length: 8, package_width: 4, package_height: 2, package_weight: 0.8 },
    { title: 'CPU Cooler', description: 'Efficient CPU cooler with heat pipes and quiet fan operation.', media: ['cpu_cooler.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.third.id, price: 39.99, quantity: 120, brand: 'CoolMaster', manufacturer: 'TechCooling', package_length: 14, package_width: 6, package_height: 4, package_weight: 0.7 },
    { title: 'Graphics Card', description: 'High-performance graphics card for smooth gaming and multimedia.', media: ['graphics_card.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.first.id, price: 299.99, quantity: 30, brand: 'PowerGFX', manufacturer: 'TechGraphics', package_length: 10, package_width: 5, package_height: 2, package_weight: 1.2 },
    { title: 'Solid State Drive (SSD)', description: 'Fast SSD storage drive for quick boot-up and file access.', media: ['ssd_drive.jpg'], category_id: Category.find_by(name: 'Computer Parts and Accessories').id, vendor_id: Vendor.second.id, price: 129.99, quantity: 50, brand: 'TurboDrive', manufacturer: 'TechStorage', package_length: 8, package_width: 4, package_height: 1, package_weight: 0.5 },
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


puts 'Seed data created successfully!'

