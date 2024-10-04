# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# db/seeds.rb

# db/seeds.rb

require 'faker'
require 'set'
# Create categories with descriptions
categories = [
  { name: 'Automotive Parts & Accessories', description: 'Spare parts for automobiles' },
  { name: 'Computer Parts & Accessories', description: 'Components and accessories for computers' },
  { name: 'Filtration', description: 'Products related to filtration solutions' },
  { name: 'Hardware Tools', description: 'Various Hardware Tools' }
]


# Create or find categories and add subcategories
categories.each do |category_data|
  category = Category.find_or_create_by(name: category_data[:name]) do |c|
    c.description = category_data[:description]
  end

  # Define subcategories based on category name
  case category.name
  when 'Automotive Parts & Accessories'
      subcategories = [
        { name: 'Batteries' },
        { name: 'Lubricants' },
        { name: 'Accessories' },
        { name: 'Spare Parts' },
        { name: 'Tyres' },
        { name: 'Others' }
      ]
  when 'Computer Parts & Accessories'
      subcategories = [
        { name: 'Cooling & Maintenance' },
        { name: 'Internal Components' },
        { name: 'Networking Equipment' },
        { name: 'Peripherals' },
        { name: 'Storage' },
        { name: 'Accessories' },
        { name: 'Others' }
      ]
  when 'Filtration'
      subcategories = [
        { name: 'Air Filters' },
        { name: 'Fuel Filters' },
        { name: 'Industrial Filters' },
        { name: 'Oil & Hydraulic Filters' },
        { name: 'Others' }
      ]
  when 'Hardware Tools'
      subcategories = [
        { name: 'Safety Wear' },
        { name: 'Hand & Power Tools' },
        { name: 'Power & Electrical Equipment' },
        { name: 'Plumbing Supplies' },
        { name: 'Others' }
      ]
  end

  # Create subcategories
  if subcategories
    subcategories.each do |subcategory_data|
      category.subcategories.find_or_create_by(name: subcategory_data[:name])
    end
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
  Purchaser.find_or_create_by(email: nil) do |purchaser|
    fullname = Faker::Name.name
    username = fullname.downcase.gsub(/\s+/, "") # remove spaces and lowercase the name
    email = "#{username}@example.com"

    purchaser.fullname = fullname
    purchaser.username = username
    purchaser.email = email
    purchaser.phone_number = generate_custom_phone_number(used_phone_numbers)
    used_phone_numbers.add(purchaser.phone_number)
    purchaser.location = Faker::Address.full_address
    purchaser.password = 'password'

    # Additional fields
    purchaser.birthdate = Faker::Date.birthday(min_age: 18, max_age: 65)
    purchaser.zipcode = Faker::Address.zip_code
    purchaser.city = Faker::Address.city
    purchaser.gender = ['Male', 'Female'].sample
    purchaser.profilepicture = Faker::Avatar.image
  end
end



# Seed vendors data
100.times do
  Vendor.find_or_create_by(email: nil) do |vendor|
    fullname = Faker::Name.name
    username = fullname.downcase.gsub(/\s+/, "") # remove spaces and lowercase the name
    email = "#{username}@example.com"

    vendor.fullname = fullname
    vendor.username = username
    vendor.email = email
    vendor.phone_number = generate_custom_phone_number(used_phone_numbers)
    used_phone_numbers.add(vendor.phone_number)
    vendor.enterprise_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    vendor.description = Faker::Company.bs
    vendor.location = Faker::Address.full_address
    vendor.password = 'password'
    vendor.business_registration_number = "BN/#{Faker::Number.number(digits: 4)}/#{Faker::Number.number(digits: 6)}"
    vendor.category_ids = [Category.all.sample.id]
    vendor.birthdate = Faker::Date.birthday(min_age: 18, max_age: 65)
    vendor.zipcode = Faker::Address.zip_code
    vendor.city = Faker::Address.city
    vendor.gender = ['Male', 'Female'].sample
    vendor.profilepicture = Faker::Avatar.image
  end
end


category_products = {
  'Filtration' => [
    { title: 'Water Filter', description: 'High-quality water filter for home use', media: ['https://m.media-amazon.com/images/I/71s7yQg7tjL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/716R+NXyn-L._AC_SX679_.jpg'] },
    { title: 'Air Purifier Filter', description: 'Filter for air purifiers', media: ['https://m.media-amazon.com/images/I/91lNyEeYIML.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/41vu1+gWIVL._AC_US100_.jpg'] },
    { title: 'HEPA Filter', description: 'High-efficiency particulate air filter for air purification', media: ['https://m.media-amazon.com/images/I/71wxFcsryqL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71f-s8DHmQL._AC_SX679_.jpg'] },
    { title: 'Carbon Filter', description: 'Activated carbon filter for water and air filtration', media: ['https://m.media-amazon.com/images/I/81UxvvXfVxL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51LAr1u0SGL._AC_US100_.jpg'] },
    { title: 'Reverse Osmosis Membrane', description: 'RO membrane for advanced water filtration', media: ['https://m.media-amazon.com/images/I/61hTq1GSb8L._SX522_.jpg', 'https://m.media-amazon.com/images/I/61VtjUpXuzS._AC_SX679_.jpg'] },
    { title: 'UV Water Filter', description: 'UV filter for sterilizing water', media: ['https://m.media-amazon.com/images/I/41EVsmhOXCL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/718ENZeONPL._SX522_.jpg'] },
    { title: 'Furnace Filter', description: 'Furnace filter for HVAC systems', media: ['https://m.media-amazon.com/images/I/81C1DwIdYYL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61WAUuZqasL._AC_SX679_.jpg'] },
    { title: 'Inline Water Filter', description: 'Inline filter for direct water filtration', media: ['https://m.media-amazon.com/images/I/71aCPQcwOVL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71-f3iKzEnL._AC_SX679_.jpg'] },
    { title: 'Pre-Filter', description: 'Pre-filter for removing larger particles from swimming pools', media: ['https://m.media-amazon.com/images/I/71+m3wn1HiL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/61Yrw-7We8L._AC_SX679_.jpg'] },
    { title: 'Sediment Filter', description: 'Sediment filter for removing dirt and rust', media: ['https://m.media-amazon.com/images/I/41sNDtAYu0L._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81v+xqbUiEL._SX522_.jpg'] },
    { title: 'Water Softener Filter', description: 'Filter for water softeners', media: ['https://m.media-amazon.com/images/I/31wyDXR3vWL._SX342_SY445_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61haYFmTEoL._SX522_.jpg'] },
    { title: 'KDF Filter', description: 'Kinetic degradation fluxion filter for water treatment', media: ['https://m.media-amazon.com/images/I/810vU+Ih0EL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71vRuQ7HGbL._AC_SX679_.jpg'] },
    { title: 'Air Purifier HEPA Filter', description: 'HEPA filter for air purifiers', media: ['https://m.media-amazon.com/images/I/71+OwDDGetL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/614mMuQUZ0L._AC_SY879_.jpg'] },
    { title: 'Odor Filter', description: 'Filter for removing odors from air', media: ['https://m.media-amazon.com/images/I/81vGvmZOEeL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81z1mRaP7JL._AC_SX679_.jpg'] },
    { title: 'Bacteria Filter', description: 'Filter for removing bacteria from water', media: ['https://m.media-amazon.com/images/I/71Bx1wF2izL._SX522_.jpg', 'https://m.media-amazon.com/images/I/61GC73Ab95L._SX522_.jpg'] },
    { title: 'Chlorine Filter', description: 'Filter for removing chlorine from water', media: ['https://m.media-amazon.com/images/I/7142R+1VUaL._AC_SX679_PIbundle-2,TopRight,0,0_SH20_.jpg', 'https://m.media-amazon.com/images/I/819lG1tbhUL._AC_SX679_.jpg'] },
    { title: 'Chemical Filter', description: 'Filter for removing chemicals from water', media: ['https://m.media-amazon.com/images/I/61tXgp2RNxL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61dsE4gjOCL._AC_SX679_.jpg'] },
    { title: 'Multi-Stage Water Filter', description: 'Multi-stage filter for comprehensive water purification', media: ['https://m.media-amazon.com/images/I/91w2Yr9CGlL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71uWouhuLAL._AC_SX679_.jpg'] },
    { title: 'Home Water Filter System', description: 'Complete water filter system for home use', media: ['https://m.media-amazon.com/images/I/71H4oBq+mrL._SX522_.jpg', 'https://m.media-amazon.com/images/I/71DT8WYFszL._SX522_.jpg'] },
    { title: 'Commercial Water Filter', description: 'Water filter system for commercial use', media: ['https://m.media-amazon.com/images/I/41oMgbWNr3L._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61KDR6vSnIL._SX522_.jpg'] },
    { title: 'Pool Filter', description: 'Filter for swimming pool water', media: ['https://m.media-amazon.com/images/I/816-kLrsA5L._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71kNgbmw53L._AC_SX679_.jpg'] },
    { title: 'Aquarium Filter', description: 'Filter for aquarium water', media: ['https://m.media-amazon.com/images/I/91amRCg3P0L._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71vF-P1IgFL._AC_SX679_.jpg'] },
    { title: 'Coffee Maker Water Filter', description: 'Filter for coffee makers', media: ['https://m.media-amazon.com/images/I/71NXo5KG+1L._AC_SX300_SY300_.jpg', 'https://m.media-amazon.com/images/I/71hDThr4LjL._AC_SX679_.jpg'] },
    { title: 'Refrigerator Water Filter', description: 'Filter for refrigerator water dispensers', media: ['https://m.media-amazon.com/images/I/61loAhZhVGL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61MKfXQ9JvL._AC_SX679_.jpg'] },
    { title: 'Under Sink Water Filter', description: 'Under sink filter for clean drinking water', media: ['https://m.media-amazon.com/images/I/610B6uiS-8L._SX522_.jpg', 'https://m.media-amazon.com/images/I/61hSjoxfr7L._SX522_.jpg'] },
    { title: 'Shower Filter', description: 'Filter for removing impurities from shower water', media: ['https://m.media-amazon.com/images/I/71KrTpNAQqL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81+GwDjeV5L._AC_SX679_.jpg'] },
    { title: 'Whole House Water Filter', description: 'Filter system for treating water for the entire house', media: ['https://m.media-amazon.com/images/I/511rtOGGL-L._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/815qfOVzErL._SX522_.jpg'] },
    { title: 'Drinking Water Filter', description: 'Filter designed specifically for drinking water', media: ['https://m.media-amazon.com/images/I/51a5ku-MyBL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81Zi4-gqDRL._SX522_.jpg'] },
    { title: 'Ice Maker Water Filter', description: 'Filter for ice maker water', media: ['https://m.media-amazon.com/images/I/6116DU4fsuL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71jya9t+Z8L._AC_SX679_.jpg'] },
    { title: 'Whole House Carbon Filter', description: 'Carbon filter for whole house water filtration', media: ['https://m.media-amazon.com/images/I/81BQ0qk5EtL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81z-yS6tnCL._AC_SX679_.jpg'] },
    { title: 'Whole House Sediment Filter', description: 'Sediment filter for whole house water filtration', media: ['https://m.media-amazon.com/images/I/613LFyIn9vL._AC_SY879_.jpg', 'https://m.media-amazon.com/images/I/71ULKqUy-cL._AC_SX679_.jpg'] },
    { title: 'Whole House UV Filter', description: 'UV filter for whole house water treatment', media: ['https://m.media-amazon.com/images/I/41aTZRXJPbL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71U3xLop+OL._SX522_.jpg'] },
    { title: 'Inline Carbon Filter', description: 'Inline carbon filter for water treatment', media: ['https://m.media-amazon.com/images/I/71i4KaaeKNL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/61cSKhB7oeL._AC_SX679_.jpg'] },
    { title: 'Inline Sediment Filter', description: 'Inline sediment filter for water treatment', media: ['https://m.media-amazon.com/images/I/51oPI2PmT-L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61u5aCr5A0L._AC_SX679_.jpg'] },
    { title: 'Inline HEPA Filter', description: 'Inline HEPA filter for air purification', media: ['https://m.media-amazon.com/images/I/51ZtOdXVjiL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/61eR-OdTnqL._AC_SX679_.jpg'] },
    { title: 'Air Purifier Carbon Filter', description: 'Carbon filter for air purifiers', media: ['https://m.media-amazon.com/images/I/8193AJLEfrL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81s2ZQUW3UL._AC_SX679_.jpg'] },
    { title: 'Central Air Filter', description: 'Filter for central air systems', media: ['https://m.media-amazon.com/images/I/81KgBUvC31L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81R78OPX5DL._AC_SX679_.jpg'] },
    { title: 'Washable Air Filter', description: 'Reusable and washable air filter', media: ['https://m.media-amazon.com/images/I/81xB6V3pLXL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81gy11y5niL._AC_SX679_.jpg'] },
    { title: 'Disposable Air Filter', description: 'Disposable filter for air purification', media: ['https://m.media-amazon.com/images/I/81LDhVskQrL._AC_SX466_.jpg', 'https://m.media-amazon.com/images/I/81I5kOL1wsL._AC_SX466_.jpg'] },
    { title: 'HEPA Air Filter', description: 'HEPA filter for air purification', media: ['https://m.media-amazon.com/images/I/710w2H0ip+L._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81cRt146vWL._AC_SX679_.jpg'] },
    { title: 'Room Air Filter', description: 'Filter designed for room air purifiers', media: ['https://m.media-amazon.com/images/I/71PRcz7h9hL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71oKUxNPx7L._AC_SX679_.jpg'] },
    { title: 'Whole House Air Filter', description: 'Air filter system for the entire house', media: ['https://m.media-amazon.com/images/I/61LxiokMpML.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81mdcI+KkpL._AC_SX679_.jpg'] },
    { title: 'Air Purifier HEPA Filter Replacement', description: 'Replacement HEPA filter for air purifiers', media: ['https://m.media-amazon.com/images/I/81EsBlbtcQL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71c8DWrE37L._AC_SX679_.jpg'] },
    { title: 'Air Purifier Carbon Filter Replacement', description: 'Replacement carbon filter for air purifiers', media: ['https://m.media-amazon.com/images/I/71fwcGskbHL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81Js5EgpSSL._AC_SX679_.jpg'] },
    { title: 'Air Purifier Pre-Filter', description: 'Pre-filter for air purifiers', media: ['https://m.media-amazon.com/images/I/812+HK6ZcAL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71nreo-aJYL._AC_SX679_.jpg'] },
    { title: 'Ozone Filter', description: 'Filter for removing ozone from air', media: ['https://m.media-amazon.com/images/I/71z8HSCIOuL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71jzbmSk8jL._AC_SX679_.jpg'] },
    { title: 'Electrostatic Filter', description: 'Electrostatic filter for air purification', media: ['https://m.media-amazon.com/images/I/71jS56bRsiL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71CTQYQ08mL._AC_SX679_.jpg'] },
    { title: 'High Efficiency Air Filter', description: 'High-efficiency air filter for HVAC systems', media: ['https://m.media-amazon.com/images/I/81V4scrfXsL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/711M8WDEeWL._AC_SX679_.jpg'] },
    { title: 'Anti-Allergen Filter', description: 'Filter designed to reduce allergens in the air', media: ['https://m.media-amazon.com/images/I/81mSMJwbU0L.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71cfK1bJqKL._AC_SX679_.jpg'] },
    { title: 'Anti-Microbial Filter', description: 'Filter with anti-microbial properties for air purification', media: ['https://m.media-amazon.com/images/I/81ji-x7WmxL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81jZUqYAx1L._AC_SX679_.jpg'] },
    { title: 'Dehumidifier Filter', description: 'Filter for dehumidifiers', media: ['https://m.media-amazon.com/images/I/61C0gFU9gmL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61ffXYuwzgL._AC_SX679_.jpg'] },
    { title: 'Ventilation Filter', description: 'Filter for ventilation systems', media: ['https://m.media-amazon.com/images/I/81xkbU3GmbL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81LowHF8DEL._AC_SX679_.jpg'] },
    { title: 'Car Air Filter', description: 'Air filter for vehicles', media: ['https://m.media-amazon.com/images/I/61nP1xuDxNL._AC_SX466_.jpg', 'https://m.media-amazon.com/images/I/717Mc8xIFWL._AC_SX466_.jpg'] },
    { title: 'Cabin Air Filter', description: 'Filter for the cabin air of vehicles', media: ['https://m.media-amazon.com/images/I/81ENfg3++0L._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/61vHKvDhCUL._AC_SX466_.jpg'] },
    { title: 'Automotive HEPA Filter', description: 'HEPA filter for vehicles', media: ['https://m.media-amazon.com/images/I/81yevjQOTSL._AC_SX466_PIbundle-2,TopRight,0,0_SH20_.jpg', 'https://m.media-amazon.com/images/I/71uMyH5Op-L._AC_SX466_.jpg'] },
    { title: 'Automotive Carbon Filter', description: 'Carbon filter for vehicles', media: ['https://m.media-amazon.com/images/I/813hKFeeYLL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81IIJPASn2L._AC_SX466_.jpg'] },
    { title: 'Automotive Cabin Filter', description: 'Cabin filter for automotive air purification', media: ['https://m.media-amazon.com/images/I/71lG3mJkZuL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71OjBaD1eXL._AC_SX679_.jpg'] },
    { title: 'Engine Air Filter', description: 'Air filter for engines', media: ['https://m.media-amazon.com/images/I/71jtD8nC2ZL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81QJJPSfgmL._AC_SX466_.jpg'] },
    { title: 'Fuel Filter', description: 'Filter for removing impurities from fuel', media: ['https://m.media-amazon.com/images/I/81+5eH1yMWL._AC_SX300_SY300_.jpg', 'https://m.media-amazon.com/images/I/61BidIQ4XyL._AC_SX679_.jpg'] },
    { title: 'Transmission Filter', description: 'Filter for transmission fluid', media: ['https://m.media-amazon.com/images/I/61V9wse3tSL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/713YCjO1neL._AC_SX466_.jpg'] },
    { title: 'Oil Filter', description: 'Filter for engine oil', media: ['https://m.media-amazon.com/images/I/810QMRHYMeL._AC_SX466_.jpg', 'https://m.media-amazon.com/images/I/710+h0PiJeL._AC_SX466_.jpg'] },
    { title: 'Automatic Transmission Filter', description: 'Filter for automatic transmission fluid', media: ['https://m.media-amazon.com/images/I/71+JB5P-GTL._AC_SX466_.jpg', 'https://m.media-amazon.com/images/I/71PxwPBeJRL._AC_SX466_.jpg'] },
    { title: 'Hydraulic Filter', description: 'Filter for hydraulic systems', media: ['https://m.media-amazon.com/images/I/61keG3JD3lL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61pPhfJcGLL._AC_SX466_.jpg'] },
    { title: 'Industrial Air Filter', description: 'Air filter for industrial applications', media: ['https://m.media-amazon.com/images/I/71z40icsuBL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71UiK0-nhcL._AC_SX679_.jpg'] },
    { title: 'Industrial Water Filter', description: 'Water filter for industrial applications', media: ['https://m.media-amazon.com/images/I/71ISSMmAeXL._SX522_.jpg', 'https://m.media-amazon.com/images/I/513J99ZpPMS._SX522_.jpg'] },
    { title: 'Commercial Air Filter', description: 'Air filter for commercial settings', media: ['https://m.media-amazon.com/images/I/718Pl0t2T0L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71T6j34Ah6L._AC_SX679_.jpg'] },
    { title: 'Commercial Water Filter', description: 'Water filter for commercial settings', media: ['https://m.media-amazon.com/images/I/61moFP4n0JL.__AC_SX300_SY300_QL70_FMwebp_.jpgq', 'https://m.media-amazon.com/images/I/71NeBKwnfqL._AC_SX679_.jpg'] },
    { title: 'Large Capacity Air Filter', description: 'High-capacity air filter for large spaces', media: ['https://m.media-amazon.com/images/I/81iDUmUZYwL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71duLXLGCRL._AC_SX679_.jpg'] },
    { title: 'Large Capacity Water Filter', description: 'High-capacity water filter for large systems', media: ['https://m.media-amazon.com/images/I/61I9DU2qI0L._AC_UL320_.jpg', 'https://m.media-amazon.com/images/I/71-9+BQCiQL._AC_UL320_.jpg'] },
    { title: 'Portable Water Filter', description: 'Portable filter for on-the-go water purification', media: ['https://m.media-amazon.com/images/I/41mZSKRLpxL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/7119OlTwurL._SX425_.jpg'] },
    { title: 'Portable Air Filter', description: 'Portable air filter for mobile use', media: ['https://m.media-amazon.com/images/I/71ZMXXzNB6L._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71vzqAKudnL.__AC_SX300_SY300_QL70_FMwebp_.jpg'] },
    { title: 'Desk Air Filter', description: 'Compact air filter for desk use', media: ['https://m.media-amazon.com/images/I/61IX7vlXEpL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81Lmplavp5L._AC_SX679_.jpg'] },
    { title: 'Air Filter Replacement', description: 'Replacement filter for air purifiers', media: ['https://m.media-amazon.com/images/I/61bE1Iw0MqL.__AC_SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71R0xEGFPvL._AC_SX679_.jpg'] },
    { title: 'Water Filter Cartridge', description: 'Cartridge for water filtration systems', media: ['https://m.media-amazon.com/images/I/71208H+OxeL._AC_SL1500_.jpg', 'https://m.media-amazon.com/images/I/71nB4mGgbLL._AC_SX679_.jpg'] },
    { title: 'Coffee Maker Water Filter Cartridge', description: 'Replacement cartridge for coffee maker water filters', media: ['https://m.media-amazon.com/images/I/81ls2BHX11S.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81wNRc7UYkL._AC_SX679_.jpg'] },
    { title: 'Refrigerator Water Filter Cartridge', description: 'Cartridge for refrigerator water filters', media: ['https://m.media-amazon.com/images/I/81HXxOWWhoL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/7176-s+CqsL._AC_SX679_.jpg'] },
    { title: 'Under Sink Filter Cartridge', description: 'Cartridge for under sink water filters', media: ['https://m.media-amazon.com/images/I/81rnj8pdAHL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81XCuq6rgUL._AC_SX679_.jpg'] },
    { title: 'Shower Filter Cartridge', description: 'Cartridge for shower water filters', media: ['https://m.media-amazon.com/images/I/71BIKNiQt9L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81eluyw2vSL._AC_SX679_.jpg'] },
    { title: 'Whole House Filter Cartridge', description: 'Cartridge for whole house water filters', media: ['https://m.media-amazon.com/images/I/81L2jVgvnxL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71EDlUTEs1L._AC_SX679_.jpg'] },
    { title: 'Pool Filter Cartridge', description: 'Cartridge for swimming pool filters', media: ['https://m.media-amazon.com/images/I/81bbsgxYnCL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81iSAjIfHGL._AC_SX679_.jpg'] },
    { title: 'Aquarium Filter Cartridge', description: 'Cartridge for aquarium filters', media: ['https://m.media-amazon.com/images/I/81Gl571Q1rL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81we3kCLlIL._AC_SX679_.jpg'] },
    { title: 'Industrial Water Filter Cartridge', description: 'Cartridge for industrial water filters', media: ['https://m.media-amazon.com/images/I/71XHS28aNZL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61L78X46gZL._AC_SX679_.jpg'] },
    { title: 'Commercial Water Filter Cartridge', description: 'Cartridge for commercial water filters', media: ['https://m.media-amazon.com/images/I/61uJ6jm0TbL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71iyxpNKSCL._AC_SX679_.jpg'] },
    { title: 'Sediment Filter Cartridge', description: 'Cartridge for sediment filters', media: ['https://m.media-amazon.com/images/I/81k7zPeY6FL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81hbTcEtXaL._AC_SX679_.jpg'] },
    { title: 'Carbon Block Filter', description: 'Carbon block filter for water purification', media: ['https://m.media-amazon.com/images/I/717R4PQZ9mL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/7149nOesF5L._AC_SX679_.jpg'] },
    { title: 'Activated Carbon Filter', description: 'Activated carbon filter for water and air', media: ['https://m.media-amazon.com/images/I/61NjIc7wccL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81sMtVyBGqL._AC_SX679_.jpg'] },
    { title: 'Ceramic Water Filter', description: 'Ceramic filter for water purification', media: ['https://m.media-amazon.com/images/I/611zBxMZgfL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/711ny4kCviL._AC_SX679_.jpg'] },
    { title: 'Titanium Water Filter', description: 'Titanium filter for advanced water filtration', media: ['https://m.media-amazon.com/images/I/41xScq-ueOL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71fOuUXPyRL._SX522_.jpg'] },
    { title: 'Stainless Steel Filter', description: 'Stainless steel filter for various applications', media: ['https://m.media-amazon.com/images/I/61IROdnY4HL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61RFSQfnJPL._AC_SX679_.jpg'] },
    { title: 'Stainless Steel Water Filter', description: 'Stainless steel filter for water purification', media: ['https://m.media-amazon.com/images/I/414h3Dr32ZL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81-J7N6-UjL._SX522_.jpg'] },
    { title: 'Sediment Removal Filter', description: 'Filter for removing sediment from water', media: ['https://m.media-amazon.com/images/I/517AJFV5ZUL._SX425_.jpg', 'https://m.media-amazon.com/images/I/81ias6INmcL._SX425_.jpg'] },
    { title: 'Pre-Carbon Filter', description: 'Pre-filter with carbon for water filtration', media: ['https://m.media-amazon.com/images/I/81mWJqCFkwL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71WOyFQje5L._AC_SX679_.jpg'] },
    { title: 'Bio Filter', description: 'Bio filter for biological water treatment', media: ['https://m.media-amazon.com/images/I/719eO7I4pZL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/610qIAstNiL._AC_SX679_.jpg'] },
    { title: 'Iron Removal Filter', description: 'Filter for removing iron from water', media: ['https://m.media-amazon.com/images/I/21USo8skpdL.__AC_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/31wPbrfjwxL._AC_.jpg'] },
    { title: 'Manganese Removal Filter', description: 'Filter for removing manganese from water', media: ['https://m.media-amazon.com/images/I/419pfSdpHAL._SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71Cj3p9OkwL._SX679_.jpg'] },
    { title: 'Copper Removal Filter', description: 'Filter for removing copper from water', media: ['https://m.media-amazon.com/images/I/71D3IJ30AgL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71VjsAJYR1L._AC_SX679_.jpg'] },
    { title: 'Nitrate Removal Filter', description: 'Filter for removing nitrates from water', media: ['https://m.media-amazon.com/images/I/71j8gSGDz9L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/616HkVma00L._AC_SX679_.jpg'] },
    { title: 'Lead Removal Filter', description: 'Filter for removing lead from water', media: ['https://m.media-amazon.com/images/I/81w59SEvixL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81pVrg-dMxL._AC_SX679_.jpg'] },
    { title: 'PFAS Removal Filter', description: 'Filter for removing PFAS from water', media: ['https://m.media-amazon.com/images/I/31O9ZBNTtyL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51Pled1H2ML._SX522_.jpg'] },
    { title: 'Arsenic Removal Filter', description: 'Filter for removing arsenic from water', media: ['https://m.media-amazon.com/images/I/41zjyCc+OeL._SX342_SY445_.jpg', 'https://m.media-amazon.com/images/I/717nbGIH5EL._SX522_.jpg'] },
    { title: 'Radon Removal Filter', description: 'Filter for removing radon from water', media: ['https://m.media-amazon.com/images/I/31CBydh4XAL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61HYp32x7XL._SX522_.jpg'] },
    { title: 'Fluoride Removal Filter', description: 'Filter for removing fluoride from water', media: ['https://m.media-amazon.com/images/I/51U-CNVnn3L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61rvh811buL._AC_SX679_.jpg'] }
  ],

  'Hardware Tools' => [
    { title: 'Hammer', description: 'Durable hammer for various tasks', media: ['https://m.media-amazon.com/images/I/716uFZq0wAL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81jHRwcu-iL._AC_SX679_.jpg'] },
    { title: 'Screwdriver Set', description: 'Set of screwdrivers with various heads', media: ['https://m.media-amazon.com/images/I/71Jli9bYEnL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/712UpxUORcL._AC_SX679_.jpg'] },
    { title: 'Adjustable Wrench', description: 'Versatile wrench for multiple applications', media: ['https://m.media-amazon.com/images/I/71sP4V5wj4L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71+5EL03z9L._AC_SX679_.jpg'] },
    { title: 'Cordless Drill', description: 'High-performance cordless drill with battery', media: ['https://m.media-amazon.com/images/I/71A+etOyhvL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71IQnMTWxaL._AC_SX679_.jpg'] },
    { title: 'Tape Measure', description: 'Reliable tape measure for accurate measurements', media: ['https://m.media-amazon.com/images/I/518quh3V+yL._SX342_SY445_.jpg', 'https://m.media-amazon.com/images/I/81y9zPytD0L._SX522_.jpg'] },
    { title: 'Utility Knife', description: 'Sharp utility knife for cutting tasks', media: ['https://m.media-amazon.com/images/I/81jVKbkaBLL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61UtU5HHtYL._AC_SX679_.jpg'] },
    { title: 'Pliers Set', description: 'Set of pliers for gripping and cutting', media: ['https://m.media-amazon.com/images/I/71Obh6ck4eL._SX522_.jpg', 'https://m.media-amazon.com/images/I/811gmjTmT7L._SX522_.jpg'] },
    { title: 'Level', description: 'Precision level for ensuring accurate alignment', media: ['https://m.media-amazon.com/images/I/71HOVTfoB4L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/717CqDHruDL._AC_SX679_.jpg'] },
    { title: 'Circular Saw', description: 'Powerful circular saw for cutting wood and other materials', media: ['https://m.media-amazon.com/images/I/81MvdZ4Y4WL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81PAM+qoPoL._AC_SX679_.jpg'] },
    { title: 'Chisel Set', description: 'Set of chisels for woodworking and carving', media: ['https://m.media-amazon.com/images/I/81lFKVfOjEL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71qXLwn5YoL._AC_SX679_.jpg'] },
    { title: 'Socket Wrench Set', description: 'Comprehensive socket wrench set for automotive work', media: ['https://m.media-amazon.com/images/I/81mI9Y+Q3XL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/81L282rWH6L._AC_SX679_.jpg'] },
    { title: 'Allen Wrench Set', description: 'Hex key set for assembling furniture and equipment', media: ['https://m.media-amazon.com/images/I/71yQBneZA3L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71XGcEufhOS._AC_SX679_.jpg'] },
    { title: 'Claw Hammer', description: 'Heavy-duty claw hammer for construction tasks', media: ['https://m.media-amazon.com/images/I/613yLITO21L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71yKenZDlzL._AC_SX679_.jpg'] },
    { title: 'Rubber Mallet', description: 'Soft rubber mallet for gentle striking', media: ['https://m.media-amazon.com/images/I/31TgPEqIv6L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51sFQ1-DkZL._AC_SX679_.jpg'] },
    { title: 'Hacksaw', description: 'Adjustable hacksaw for cutting metal and plastic', media: ['https://m.media-amazon.com/images/I/61kka0uhdeL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71TQz3kX4cL._AC_SX679_.jpg'] },
    { title: 'Handsaw', description: 'Sharp handsaw for precise cutting of wood', media: ['https://m.media-amazon.com/images/I/61XIfJcQIuL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71eOWnKfG2L._AC_SX679_.jpg'] },
    { title: 'Jigsaw', description: 'Electric jigsaw for curved and intricate cuts', media: ['https://m.media-amazon.com/images/I/71fbAzlbkZL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/814L+FwzJYL._AC_SX679_.jpg'] },
    { title: 'Sledgehammer', description: 'Heavy sledgehammer for demolition work', media: ['https://m.media-amazon.com/images/I/71oD+cxcBZL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71bcfFhJ2qL._AC_SX679_.jpg'] },
    { title: 'Pipe Wrench', description: 'Adjustable pipe wrench for plumbing tasks', media: ['https://m.media-amazon.com/images/I/71J7GQK-Z0S._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/61dUJ6357vS._AC_SX679_.jpg'] },
    { title: 'Needle-Nose Pliers', description: 'Long-nose pliers for reaching tight spaces', media: ['https://m.media-amazon.com/images/I/71EQquE38wL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/818lBmotnXL._AC_SX679_.jpg'] },
    { title: 'Vise Grip Pliers', description: 'Locking pliers with adjustable grip', media: ['https://m.media-amazon.com/images/I/81djRUffIgL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71AkMqCs0VL._AC_SX679_.jpg'] },
    { title: 'Crescent Wrench', description: 'Adjustable crescent wrench for various nuts and bolts', media: ['https://m.media-amazon.com/images/I/61f2DwuAxYL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61f1MqGwmBL._AC_SX679_.jpg'] },
    { title: 'Tin Snips', description: 'Sharp tin snips for cutting sheet metal', media: ['https://m.media-amazon.com/images/I/71vTvEFqtpL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/610TIjPJxcS.__AC_SX300_SY300_QL70_FMwebp_.jpg'] },
    { title: 'Wire Strippers', description: 'Precision wire strippers for electrical work', media: ['https://m.media-amazon.com/images/I/61OtPfu3CzL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71bqoqtZzHL._AC_SX679_.jpg'] },
    { title: 'Bolt Cutters', description: 'Heavy-duty bolt cutters for cutting metal rods and chains', media: ['https://m.media-amazon.com/images/I/71Vzq9bvtfL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71Se1duvlxL._AC_SX679_.jpg'] },
    { title: 'Staple Gun', description: 'Manual staple gun for fastening materials', media: ['https://m.media-amazon.com/images/I/71m9qQMPgFL._AC_SX466_.jpg', 'https://m.media-amazon.com/images/I/71oKh5ETShL._AC_SX466_.jpg'] },
    { title: 'Impact Driver', description: 'High-torque impact driver for driving screws and bolts', media: ['https://m.media-amazon.com/images/I/81iNvQfH7gL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/619iurcED8L._AC_SX679_.jpg'] },
    { title: 'Angle Grinder', description: 'Powerful angle grinder for grinding and cutting', media: ['https://m.media-amazon.com/images/I/51eahVbzdSL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61t2sy3YZzL._AC_SX679_.jpg'] },
    { title: 'Table Saw', description: 'Large table saw for woodworking projects', media: ['https://m.media-amazon.com/images/I/71tgjjKcv-L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71AJlS4qvyL._AC_SX679_.jpg'] },
    { title: 'Miter Saw', description: 'Precision miter saw for angled cuts', media: ['https://m.media-amazon.com/images/I/71JGd3UiTRL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71Vkx91yAyL._AC_SX679_.jpg'] },
    { title: 'Rotary Tool', description: 'Versatile rotary tool for sanding, cutting, and engraving', media: ['https://m.media-amazon.com/images/I/712Ff5malcL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/91FftJ7318L._AC_SX679_.jpg'] },
    { title: 'Heat Gun', description: 'Adjustable heat gun for stripping paint and other tasks', media: ['https://m.media-amazon.com/images/I/61kEj+o6tQL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/71Sz5Rukk8L._AC_SX679_.jpg'] },
    { title: 'Soldering Iron', description: 'Electric soldering iron for electronic repairs', media: ['https://m.media-amazon.com/images/I/71yimJ+NaFL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71r1mV1mH5L._AC_SX679_.jpg'] },
    { title: 'Combination Square', description: 'Multi-purpose combination square for measuring and marking', media: ['https://m.media-amazon.com/images/I/312iNTCUE5L._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/811r5bWvpxL._SX522_.jpg'] },
    { title: 'Carpenters Pencil', description: 'Durable pencil for marking wood and other materials', media: ['https://m.media-amazon.com/images/I/81eLZAbHHML.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71q8uVmpvcL._AC_SX466_.jpg'] },
    { title: 'C-Clamps', description: 'Strong C-clamps for holding materials in place', media: ['https://m.media-amazon.com/images/I/8139J2uXMTL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71aPBcUTJML._AC_SX679_.jpg'] },
    { title: 'Bar Clamps', description: 'Adjustable bar clamps for woodworking and assembly', media: ['https://m.media-amazon.com/images/I/71UYpgc6-HL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81rzUw14DNL._AC_SX679_.jpg'] },
    { title: 'G-Clamps', description: 'Heavy-duty G-clamps for securing workpieces', media: ['https://m.media-amazon.com/images/I/710MGTSxm8L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61UZ6PievmL._AC_SX679_.jpg'] },
    { title: 'Wood Rasp', description: 'Coarse wood rasp for shaping and smoothing wood', media: ['https://m.media-amazon.com/images/I/61cxQpKQoEL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61DTuYYbGdL._AC_SX679_.jpg'] },
    { title: 'Flat File', description: 'Flat file for smoothing metal and other materials', media: ['https://m.media-amazon.com/images/I/71mGV3zMs9L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71BPSf84waL._AC_SX679_.jpg'] },
    { title: 'Round File', description: 'Round file for enlarging holes and shaping curves', media: ['https://m.media-amazon.com/images/I/41fMVD2DJ8L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61Xu3e2rqUL._AC_SX679_.jpg'] },
    { title: 'Sandpaper Assortment', description: 'Variety pack of sandpaper for different grits', media: ['https://m.media-amazon.com/images/I/41PP0aIh8aL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61-P-QrLylL._SX522_.jpg'] },
    { title: 'Workbench', description: 'Sturdy workbench for all your projects', media: ['https://m.media-amazon.com/images/I/618vITicOHL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81etNsHTvRL._AC_SX679_.jpg'] },
    { title: 'Toolbox', description: 'Portable toolbox for organizing tools', media: ['https://m.media-amazon.com/images/I/81ctsQRl7eL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81Cm17mVasL._AC_SX679_.jpg'] },
    { title: 'Tool Belt', description: 'Convenient tool belt for carrying essentials', media: ['https://m.media-amazon.com/images/I/71w9dp+aDeL._AC_SX300_SY300_.jpg', 'https://m.media-amazon.com/images/I/71abOgzszQL._AC_SX679_.jpg'] },
    { title: 'Safety Goggles', description: 'Protective safety goggles for eye protection', media: ['https://m.media-amazon.com/images/I/71dkYvW25kL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/818AeSmnm2L._AC_SX679_.jpg'] },
    { title: 'Ear Protection', description: 'Noise-cancelling ear protection for loud environments', media: ['https://m.media-amazon.com/images/I/51bG7MeJKmL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61Vrh4epovL._AC_SX679_.jpg'] },
    { title: 'Work Gloves', description: 'Durable work gloves for hand protection', media: ['https://m.media-amazon.com/images/I/71jQo103aYL._AC_SX569_.jpg', 'https://m.media-amazon.com/images/I/71gbA3AZgtL._AC_SX569_.jpg'] },
    { title: 'Knee Pads', description: 'Comfortable knee pads for extended work', media: ['https://m.media-amazon.com/images/I/918SUjGqL7L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81aSP3tzuDL._AC_SX679_.jpg'] },
    { title: 'Dust Mask', description: 'Breathable dust mask for protection from particles', media: ['https://m.media-amazon.com/images/I/51-zA01VM0L._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71kGH27cAyL._SX522_.jpg'] },
    { title: 'Hard Hat', description: 'Impact-resistant hard hat for head protection', media: ['https://m.media-amazon.com/images/I/61Bb2fHXKLL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71yMktJdmzL._AC_SX679_.jpg'] },
    { title: 'Respirator', description: 'Advanced respirator for protection from fumes and dust', media: ['https://m.media-amazon.com/images/I/61XtPAT+93L._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/61VgB8zFnfL._AC_SX569_.jpg'] },
    { title: 'Utility Apron', description: 'Heavy-duty utility apron with multiple pockets', media: ['https://m.media-amazon.com/images/I/81wr3MTAr8L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81SnmSC3HNL._AC_SY879_.jpg'] },
    { title: 'Extension Cord', description: 'Long extension cord for powering tools at a distance', media: ['https://m.media-amazon.com/images/I/61snPWDxzzL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71rK8sHxufL._AC_SX466_.jpg'] },
    { title: 'Work Light', description: 'Bright work light for illuminating your workspace', media: ['https://m.media-amazon.com/images/I/61tT1KI5PlL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71YNBHQf+IL._AC_SX679_.jpg'] },
    { title: 'Ladder', description: 'Sturdy ladder for reaching high places', media: ['https://m.media-amazon.com/images/I/71B7tmfBv6L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71G-TaBnCvL._AC_SX679_.jpg'] },
    { title: 'Step Stool', description: 'Compact step stool for easy access to elevated areas', media: ['https://m.media-amazon.com/images/I/61tRnD2doxL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71TUPsztExL._AC_SX679_.jpg'] },
    { title: 'Extension Ladder', description: 'Adjustable extension ladder for extended reach', media: ['https://m.media-amazon.com/images/I/61QZzN5+1vL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/71jBZ2+IuxL._AC_SX679_.jpg'] },
    { title: 'Sawhorse', description: 'Durable sawhorse for supporting workpieces', media: ['https://m.media-amazon.com/images/I/61WySW68U-L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71sDKG44f1L._AC_SX679_.jpg'] },
    { title: 'Folding Workbench', description: 'Portable folding workbench for on-the-go projects', media: ['https://m.media-amazon.com/images/I/71m6C34VnrL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71JkiNjKGlL._AC_SX679_.jpg'] },
    { title: 'Tool Organizer', description: 'Wall-mounted tool organizer for easy access', media: ['https://m.media-amazon.com/images/I/81wRxczINnL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/9140yTMMEoL._AC_SX679_.jpg'] },
    { title: 'Magnetic Tool Holder', description: 'Magnetic tool holder for quick storage', media: ['https://m.media-amazon.com/images/I/513ozkjjvGL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71uDRc46PwL._AC_SX679_.jpg'] },
    { title: 'Tool Chest', description: 'Large tool chest for comprehensive tool storage', media: ['https://m.media-amazon.com/images/I/71-ouJPDYhL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71NQnEueABL._AC_SX679_.jpg'] },
    { title: 'Drill Bit Set', description: 'Assorted drill bit set for various materials', media: ['https://m.media-amazon.com/images/I/81+SvTR3+JL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/81wioUD3ssL._AC_SX679_.jpg'] },
    { title: 'Hole Saw Kit', description: 'Complete hole saw kit for cutting large holes', media: ['https://m.media-amazon.com/images/I/51wynj3sddL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71IxXiZbnFL._SX522_.jpg'] },
    { title: 'Wood Router', description: 'Powerful wood router for shaping and trimming', media: ['https://m.media-amazon.com/images/I/51u4TdCO0lL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71E9xdt8eML._AC_SX679_.jpg'] },
    { title: 'Belt Sander', description: 'Electric belt sander for smoothing surfaces', media: ['https://m.media-amazon.com/images/I/7154x92t4kL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81f0zV6-5FL._AC_SX679_.jpg'] },
    { title: 'Orbital Sander', description: 'Random orbital sander for a smooth finish', media: ['https://m.media-amazon.com/images/I/61gLO6tD4UL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/511JpjT5GfL._AC_SX679_.jpg'] },
    { title: 'Palm Sander', description: 'Compact palm sander for detailed work', media: ['https://m.media-amazon.com/images/I/614hw+xGqqL._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/61GYqcSZAHL._AC_SX679_.jpg'] },
    { title: 'Bench Grinder', description: 'Sturdy bench grinder for sharpening tools', media: ['https://m.media-amazon.com/images/I/71RkIjRxEtL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71t3cA4WuxL._AC_SX679_.jpg'] },
    { title: 'Chop Saw', description: 'Heavy-duty chop saw for cutting metal and wood', media: ['https://m.media-amazon.com/images/I/516DPmowaZL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61mfozi-qEL._AC_SX679_.jpg'] },
    { title: 'Reciprocating Saw', description: 'Versatile reciprocating saw for demolition work', media: ['https://m.media-amazon.com/images/I/61kKygrI4TL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51nm+HzJr5L._AC_SX679_.jpg'] },
    { title: 'Planer', description: 'Electric planer for smoothing and leveling wood', media: ['https://m.media-amazon.com/images/I/615gGtCh5NL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51XB-L-Z-6L._AC_SX679_.jpg'] },
    { title: 'Nail Gun', description: 'Pneumatic nail gun for fast and efficient nailing', media: ['https://m.media-amazon.com/images/I/81JDHz6fLtL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71-oAwe2UbL._AC_SX466_.jpg'] },
    { title: 'Staple Gun', description: 'Electric staple gun for upholstery and crafts', media: ['https://m.media-amazon.com/images/I/61B2TFDpMlL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61Dap3N3VpL._AC_SX466_.jpg'] },
    { title: 'Brad Nailer', description: 'Precision brad nailer for trim work', media: ['https://m.media-amazon.com/images/I/61T322zrfmL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71ecy4FYRlL._AC_SX679_.jpg'] },
    { title: 'Finish Nailer', description: 'Finish nailer for carpentry and finishing tasks', media: ['https://m.media-amazon.com/images/I/61p5o9ddMPL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61jyLia1oTL._AC_SX679_.jpg'] },
    { title: 'Palm Nailer', description: 'Compact palm nailer for tight spaces', media: ['https://m.media-amazon.com/images/I/71e4QBSXUaL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71BgqlVUJaL._AC_SX679_.jpg'] },
    { title: 'Air Compressor', description: 'Portable air compressor for powering pneumatic tools', media: ['https://m.media-amazon.com/images/I/71BSPHh9Q0L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61CzbyxsRKL._AC_SX679_.jpg'] },
    { title: 'Air Hose', description: 'Flexible air hose for connecting pneumatic tools', media: ['https://m.media-amazon.com/images/I/61BmmE3TnTL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61Bj+P-Jb3L._AC_SX679_.jpg'] },
    { title: 'Air Tool Kit', description: 'Complete air tool kit for various applications', media: ['https://m.media-amazon.com/images/I/81IXzEeQudL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81BelRXV4OL.__AC_SY300_SX300_QL70_FMwebp_.jpg'] },
    { title: 'Shop Vacuum', description: 'Powerful shop vacuum for cleaning up debris', media: ['https://m.media-amazon.com/images/I/61dWWfPxfQL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71xANU3Mj-L._AC_SX679_.jpg'] },
    { title: 'Dust Collector', description: 'Efficient dust collector for woodworking shops', media: ['https://m.media-amazon.com/images/I/61xiZoGu6xS.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71ukUVXuxeL._AC_SX679_.jpg'] },
    { title: 'Blower', description: 'Electric blower for clearing leaves and debris', media: ['https://m.media-amazon.com/images/I/71Apl1BHUPL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81fBgiBMDCL._AC_SX679_.jpg'] },
    { title: 'Pressure Washer', description: 'High-pressure washer for cleaning surfaces', media: ['https://m.media-amazon.com/images/I/71QvIwb6ahL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81SnAGgTJmL._AC_SX679_.jpg'] },
    { title: 'Power Washer', description: 'Gas-powered washer for heavy-duty cleaning', media: ['https://m.media-amazon.com/images/I/718rtiNuh6L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71m2Tl5ML6L._AC_SX679_.jpg'] },
    { title: 'Paint Sprayer', description: 'Electric paint sprayer for smooth and even coverage', media: ['https://m.media-amazon.com/images/I/617t6Ti5pLL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71Zo-NMWnTL._AC_SX679_.jpg'] },
    { title: 'Caulking Gun', description: 'Manual caulking gun for sealing joints', media: ['https://m.media-amazon.com/images/I/61EQ+H2sE0L._AC_SY300_SX300_.jpg', 'https://m.media-amazon.com/images/I/716esq+5fbL._AC_SX679_.jpg'] },
    { title: 'Putty Knife', description: 'Flexible putty knife for spreading and scraping', media: ['https://m.media-amazon.com/images/I/61qBVm7Rf1L.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61fXAXK2i8L._AC_SX679_.jpg'] },
    { title: 'Painters Tape', description: 'High-quality painters tape for clean lines', media: ['https://m.media-amazon.com/images/I/41nZpaJSzQL._SY445_SX342_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61m-bnYdbpL._SX522_.jpg'] },
    { title: 'Paint Roller', description: 'Durable paint roller for even application', media: ['https://m.media-amazon.com/images/I/71QZSL63XJL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81H4fiePfYL._AC_SX679_.jpg'] },
    { title: 'Paint Tray', description: 'Sturdy paint tray for holding paint and rollers', media: ['https://m.media-amazon.com/images/I/71Br9Hl2CFL._AC_SX679_.jpg', 'https://m.media-amazon.com/images/I/81D86IacnCL._AC_SX679_.jpg'] },
    { title: 'Paintbrush Set', description: 'Set of paintbrushes for detailed painting', media: ['https://m.media-amazon.com/images/I/71JEXuFLJPL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/71lMvpYIUSL._AC_SX679_.jpg'] },
    { title: 'Drop Cloth', description: 'Protective drop cloth for covering surfaces', media: ['https://m.media-amazon.com/images/I/71-8ayBX5VL.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81j9gEv4jtL._AC_SX679_.jpg'] },
    { title: 'Lawn Mower', description: 'Gas-powered lawn mower for cutting grass', media: ['https://m.media-amazon.com/images/I/51I8NfZeCyS.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/616BtWwlH3S._AC_SX679_.jpg'] },
    { title: 'Electric Lawn Mower', description: 'Eco-friendly electric lawn mower', media: ['https://m.media-amazon.com/images/I/51QofBq3BrL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/610p86psDpL._AC_SX679_.jpg'] },
    { title: 'String Trimmer', description: 'Cordless string trimmer for edging and trimming', media: ['https://m.media-amazon.com/images/I/61a1lOmJdNL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/81m5hNXEAeL._AC_SX679_.jpg'] },
    { title: 'Hedge Trimmer', description: 'Electric hedge trimmer for shaping bushes', media: ['https://m.media-amazon.com/images/I/61qNJClJ2UL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/616s6F7pgjL._AC_SX679_.jpg'] },
    { title: 'Leaf Blower', description: 'High-speed leaf blower for clearing debris', media: ['https://m.media-amazon.com/images/I/71m9PcGevSL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/51XvOxfx-FL._AC_.jpg'] },
    { title: 'Chainsaw', description: 'Powerful chainsaw for cutting trees and branches', media: ['https://m.media-amazon.com/images/I/61vXLawhV1L.__AC_SY300_SX300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61gnCtuf3GL._AC_SX679_.jpg'] },
    { title: 'Garden Shovel', description: 'Heavy-duty garden shovel for digging', media: ['https://m.media-amazon.com/images/I/61itLoCAIlL.__AC_SX300_SY300_QL70_FMwebp_.jpg', 'https://m.media-amazon.com/images/I/61vemSxhZAL._AC_SY879_.jpg'] }
  ],

  'Automotive Parts & Accessories' => [
    { title: 'Car Battery', description: 'Long-lasting car battery', media: ['', ''] },
    { title: 'Brake Pads', description: 'High-quality brake pads for cars', media: ['', ''] },
    { title: 'Oil Filter', description: 'Filter for cleaning engine oil', media: ['', ''] },
    { title: 'Air Filter', description: 'Filter for cleaning air entering the engine', media: ['', ''] },
    { title: 'Fuel Filter', description: 'Filter for cleaning fuel', media: ['', ''] },
    { title: 'Spark Plugs', description: 'Spark plugs for ignition systems', media: ['', ''] },
    { title: 'Headlights', description: 'Replacement headlights for vehicles', media: ['', ''] },
    { title: 'Tail Lights', description: 'Replacement tail lights for vehicles', media: ['', ''] },
    { title: 'Alternator', description: 'Alternator for charging the vehicle battery', media: ['', ''] },
    { title: 'Starter Motor', description: 'Starter motor for starting the engine', media: ['', ''] },
    { title: 'Water Pump', description: 'Water pump for cooling system', media: ['', ''] },
    { title: 'Radiator', description: 'Radiator for cooling the engine', media: ['', ''] },
    { title: 'Timing Belt', description: 'Timing belt for engine synchronization', media: ['', ''] },
    { title: 'Timing Chain', description: 'Timing chain for engine synchronization', media: ['', ''] },
    { title: 'Transmission Filter', description: 'Filter for cleaning transmission fluid', media: ['', ''] },
    { title: 'Power Steering Pump', description: 'Pump for power steering system', media: ['', ''] },
    { title: 'Brake Rotors', description: 'Rotors for braking system', media: ['', ''] },
    { title: 'Clutch Kit', description: 'Complete clutch kit for manual transmission', media: ['', ''] },
    { title: 'Suspension Struts', description: 'Suspension struts for vehicle stability', media: ['', ''] },
    { title: 'Shock Absorbers', description: 'Shock absorbers for smooth driving', media: ['', ''] },
    { title: 'Fuel Pump', description: 'Pump for delivering fuel to the engine', media: ['', ''] },
    { title: 'Battery Charger', description: 'Charger for maintaining car battery', media: ['', ''] },
    { title: 'Car Filters', description: 'Various filters for vehicle maintenance', media: ['', ''] },
    { title: 'Brake Calipers', description: 'Calipers for the braking system', media: ['', ''] },
    { title: 'Wheel Bearings', description: 'Bearings for wheel rotation', media: ['', ''] },
    { title: 'Drive Belts', description: 'Belts for powering accessories', media: ['', ''] },
    { title: 'Serpentine Belt', description: 'Belt for driving multiple accessories', media: ['', ''] },
    { title: 'Fuel Injectors', description: 'Injectors for delivering fuel into the engine', media: ['', ''] },
    { title: 'Radiator Hoses', description: 'Hoses for connecting radiator to engine', media: ['', ''] },
    { title: 'Thermostat', description: 'Thermostat for regulating engine temperature', media: ['', ''] },
    { title: 'Cylinder Head', description: 'Head for engine cylinder block', media: ['', ''] },
    { title: 'Engine Block', description: 'Engine block for housing engine components', media: ['', ''] },
    { title: 'Piston Rings', description: 'Rings for sealing pistons in the engine', media: ['', ''] },
    { title: 'Crankshaft', description: 'Crankshaft for converting piston movement', media: ['', ''] },
    { title: 'Camshaft', description: 'Camshaft for operating engine valves', media: ['', ''] },
    { title: 'Turbocharger', description: 'Turbocharger for increasing engine power', media: ['', ''] },
    { title: 'Supercharger', description: 'Supercharger for boosting engine performance', media: ['', ''] },
    { title: 'Exhaust Manifold', description: 'Manifold for directing exhaust gases', media: ['', ''] },
    { title: 'Intake Manifold', description: 'Manifold for distributing air-fuel mixture', media: ['', ''] },
    { title: 'Catalytic Converter', description: 'Converter for reducing exhaust emissions', media: ['', ''] },
    { title: 'Oxygen Sensors', description: 'Sensors for monitoring exhaust gases', media: ['', ''] },
    { title: 'Mass Air Flow Sensor', description: 'Sensor for measuring air flow into the engine', media: ['', ''] },
    { title: 'Idle Air Control Valve', description: 'Valve for controlling engine idle speed', media: ['', ''] },
    { title: 'PCV Valve', description: 'Valve for controlling crankcase ventilation', media: ['', ''] },
    { title: 'EGR Valve', description: 'Valve for recirculating exhaust gases', media: ['', ''] },
    { title: 'Fuel Tank', description: 'Tank for storing fuel', media: ['', ''] },
    { title: 'Fuel Tank Sender', description: 'Sender for fuel level measurement', media: ['', ''] },
    { title: 'Fuel Filler Cap', description: 'Cap for sealing the fuel tank', media: ['', ''] },
    { title: 'Power Window Motor', description: 'Motor for operating power windows', media: ['', ''] },
    { title: 'Door Lock Actuator', description: 'Actuator for locking and unlocking doors', media: ['', ''] },
    { title: 'Window Regulator', description: 'Regulator for operating window movement', media: ['', ''] },
    { title: 'Ignition Coil', description: 'Coil for igniting the air-fuel mixture', media: ['', ''] },
    { title: 'Distributor Cap', description: 'Cap for distributing electrical current', media: ['', ''] },
    { title: 'Rotor Arm', description: 'Arm for distributing electrical current', media: ['', ''] },
    { title: 'Wiper Blades', description: 'Blades for cleaning the windshield', media: ['', ''] },
    { title: 'Wiper Motor', description: 'Motor for operating windshield wipers', media: ['', ''] },
    { title: 'Windshield Washer Pump', description: 'Pump for windshield washer fluid', media: ['', ''] },
    { title: 'Head Gasket', description: 'Gasket for sealing the engine head', media: ['', ''] },
    { title: 'Valve Cover Gasket', description: 'Gasket for sealing the valve cover', media: ['', ''] },
    { title: 'Oil Pan Gasket', description: 'Gasket for sealing the oil pan', media: ['', ''] },
    { title: 'Transmission Pan Gasket', description: 'Gasket for sealing the transmission pan', media: ['', ''] },
    { title: 'Differential Fluid', description: 'Fluid for lubricating the differential', media: ['', ''] },
    { title: 'Gear Oil', description: 'Oil for lubricating gear systems', media: ['', ''] },
    { title: 'Transmission Fluid', description: 'Fluid for transmission lubrication', media: ['', ''] },
    { title: 'Brake Fluid', description: 'Fluid for the braking system', media: ['', ''] },
    { title: 'Coolant', description: 'Coolant for engine temperature regulation', media: ['', ''] },
    { title: 'Engine Oil', description: 'Oil for engine lubrication', media: ['', ''] },
    { title: 'Cabin Air Filter', description: 'Filter for air inside the vehicle cabin', media: ['', ''] },
    { title: 'Engine Mounts', description: 'Mounts for securing the engine', media: ['', ''] },
    { title: 'Transmission Mounts', description: 'Mounts for securing the transmission', media: ['', ''] },
    { title: 'Suspension Bushings', description: 'Bushings for suspension system', media: ['', ''] },
    { title: 'Tie Rod Ends', description: 'Ends for steering linkage', media: ['', ''] },
    { title: 'Ball Joints', description: 'Joints for suspension and steering', media: ['', ''] },
    { title: 'Control Arms', description: 'Arms for controlling wheel movement', media: ['', ''] },
    { title: 'Strut Mounts', description: 'Mounts for struts in the suspension', media: ['', ''] },
    { title: 'Shock Absorber Mounts', description: 'Mounts for shock absorbers', media: ['', ''] },
    { title: 'Leaf Springs', description: 'Springs for vehicle suspension', media: ['', ''] },
    { title: 'Coil Springs', description: 'Springs for vehicle suspension', media: ['', '']   },
    { title: 'Anti-Sway Bars', description: 'Bars for reducing body roll', media: ['', '']   },
    { title: 'Drive Shafts', description: 'Shafts for transferring power from the engine', media: ['', '']   },
    { title: 'Axle Shafts', description: 'Shafts for transferring power to the wheels', media: ['', '']   },
    { title: 'Differential Gears', description: 'Gears for the differential system', media: ['', '']   },
    { title: 'Wheel Hubs', description: 'Hubs for mounting wheels', media: ['', '']   },
    { title: 'Wheel Studs', description: 'Studs for securing wheels', media: ['', '']   },
    { title: 'Lug Nuts', description: 'Nuts for securing wheels' , media: ['', '']  },
    { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset', media: ['', '']   },
    { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure', media: ['', '']   },
    { title: 'Oil Cooler', description: 'Cooler for regulating engine oil temperature', media: ['', '']   },
    { title: 'Transmission Cooler', description: 'Cooler for regulating transmission fluid temperature', media: ['', '']   },
    { title: 'Intercooler', description: 'Cooler for reducing intake air temperature', media: ['', '']   },
    { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers', media: ['', '']   },
    { title: 'Supercharger Kits', description: 'Kits for installing superchargers', media: ['', '']   },
    { title: 'Engine Rebuild Kits', description: 'Kits for rebuilding engines', media: ['', '']   },
    { title: 'Cylinder Heads', description: 'Heads for engine cylinders', media: ['', '']   },
    { title: 'Pistons', description: 'Pistons for engine cylinders', media: ['', '']   },
    { title: 'Connecting Rods', description: 'Rods for connecting pistons to the crankshaft', media: ['', '']   },
    { title: 'Crankshafts', description: 'Crankshafts for converting piston movement', media: ['', '']   },
    { title: 'Camshafts', description: 'Camshafts for operating engine valves', media: ['', '']   },
    { title: 'Water Pump Pulley', description: 'Pulley for driving the water pump', media: ['', '']   },
    { title: 'Alternator Pulley', description: 'Pulley for driving the alternator', media: ['', '']   },
    { title: 'Power Steering Pulley', description: 'Pulley for driving the power steering pump', media: ['', '']   }
  ],

  'Computer Parts & Accessories' => [
    { title: 'Graphics Card', description: 'High-performance graphics card for gaming', media: ['', '']  },
    { title: 'RAM Module', description: '8GB RAM module for computers', media: ['', '']  },
    { title: 'Solid State Drive', description: '500GB SSD for faster storage', media: ['', '']  },
    { title: 'Hard Disk Drive', description: '1TB HDD for additional storage', media: ['', '']  },
    { title: 'Motherboard', description: 'ATX motherboard with multiple ports', media: ['', '']  },
    { title: 'Processor', description: 'Intel i7 processor for high-speed computing', media: ['', '']  },
    { title: 'Power Supply Unit', description: '650W PSU for reliable power delivery', media: ['', '']  },
    { title: 'CPU Cooler', description: 'High-performance CPU cooler for overclocking', media: ['', '']  },
    { title: 'Computer Case', description: 'Mid-tower case with cable management', media: ['', '']  },
    { title: 'Gaming Keyboard', description: 'Mechanical keyboard with RGB lighting', media: ['', '']  },
    { title: 'Gaming Mouse', description: 'Ergonomic mouse with customizable DPI settings', media: ['', '']  },
    { title: 'Monitor', description: '27-inch 4K monitor for sharp visuals', media: ['', '']  },
    { title: 'Headset', description: 'Gaming headset with surround sound', media: ['', '']  },
    { title: 'Webcam', description: '1080p webcam for clear video calls', media: ['', '']  },
    { title: 'External Hard Drive', description: '2TB external drive for backup', media: ['', '']  },
    { title: 'USB Hub', description: '7-port USB hub for connecting multiple devices', media: ['', '']  },
    { title: 'Optical Drive', description: 'DVD-RW drive for reading and writing discs', media: ['', '']  },
    { title: 'Network Card', description: 'Dual-band Wi-Fi card for faster internet', media: ['', '']  },
    { title: 'Sound Card', description: 'External sound card for enhanced audio quality', media: ['', '']  },
    { title: 'Cooling Fan', description: '120mm cooling fan for improved airflow', media: ['', '']  },
    { title: 'Thermal Paste', description: 'High-performance thermal paste for CPUs', media: ['', '']  },
    { title: 'Mouse Pad', description: 'Large mouse pad with smooth surface', media: ['', '']  },
    { title: 'Power Strip', description: 'Surge-protected power strip with USB ports', media: ['', '']  },
    { title: 'Cable Management Kit', description: 'Kit for organizing cables and wires', media: ['', '']  },
    { title: 'Computer Stand', description: 'Adjustable stand for ergonomic positioning', media: ['', '']  },
    { title: 'Docking Station', description: 'Docking station for connecting multiple peripherals', media: ['', '']  },
    { title: 'Bluetooth Adapter', description: 'Bluetooth adapter for wireless connectivity', media: ['', '']  },
    { title: 'Case Fans', description: 'Set of case fans for cooling', media: ['', '']  },
    { title: 'External SSD', description: '1TB external SSD for fast storage', media: ['', '']  },
    { title: 'Thermal Paste Cleaner', description: 'Cleaner for removing old thermal paste', media: ['', '']  },
    { title: 'BIOS Battery', description: 'Replacement battery for motherboard BIOS', media: ['', '']  },
    { title: 'CPU Thermal Pad', description: 'Thermal pad for CPU cooling', media: ['', '']  },
    { title: 'Laptop Docking Station', description: 'Docking station for laptops with multiple ports', media: ['', '']  },
    { title: 'Wireless Keyboard', description: 'Wireless keyboard with quiet keys', media: ['', '']  },
    { title: 'Wireless Mouse', description: 'Wireless mouse with long battery life', media: ['', '']  },
    { title: 'Multi-Monitor Stand', description: 'Stand for holding multiple monitors', media: ['', '']  },
    { title: 'Portable Monitor', description: '15.6-inch portable monitor for on-the-go use', media: ['', '']  },
    { title: 'USB Flash Drive', description: '32GB USB flash drive for data transfer', media: ['', '']  },
    { title: 'External Optical Drive', description: 'External DVD drive for laptops', media: ['', '']  },
    { title: 'Laptop Cooling Pad', description: 'Cooling pad for laptops with fans', media: ['', '']  },
    { title: 'VR Headset', description: 'Virtual reality headset for immersive experiences', media: ['', '']  },
    { title: 'Cable Sleeving Kit', description: 'Kit for customizing and organizing cables', media: ['', '']  },
    { title: 'USB to Ethernet Adapter', description: 'Adapter for adding Ethernet connectivity via USB', media: ['', '']  },
    { title: 'PCIe Expansion Card', description: 'Expansion card for additional PCIe slots', media: ['', '']  },
    { title: 'M.2 SSD', description: '500GB M.2 SSD for ultra-fast storage', media: ['', '']  },
    { title: 'Memory Card Reader', description: 'Reader for various memory card formats', media: ['', '']  },
    { title: 'PC Cleaning Kit', description: 'Kit for cleaning and maintaining your PC', media: ['', '']  },
    { title: 'Digital Pen Tablet', description: 'Tablet for digital drawing and note-taking', media: ['', '']  },
    { title: 'Microphone', description: 'High-quality microphone for recording and streaming', media: ['', '']  },
    { title: 'Laptop Case', description: 'Protective case for laptops', media: ['', '']  },
    { title: 'Mouse Bungee', description: 'Bungee for managing mouse cable', media: ['', '']  },
    { title: 'Laptop Stand', description: 'Adjustable stand for laptop ergonomics', media: ['', '']  },
    { title: 'Graphics Card Stand', description: 'Stand for stabilizing large graphics cards', media: ['', '']  },
    { title: 'Memory Heat Spreader', description: 'Heat spreader for RAM modules', media: ['', '']  },
    { title: 'Cooling System', description: 'Advanced cooling system for high-performance PCs', media: ['', '']  },
    { title: 'Computer Dust Filter', description: 'Filter for keeping dust out of your PC case', media: ['', '']  },
    { title: 'USB-C Hub', description: 'Hub for expanding USB-C connectivity', media: ['', '']  },
    { title: 'KVM Switch', description: 'Switch for controlling multiple computers with one set of peripherals', media: ['', '']  },
    { title: 'Network Switch', description: 'Network switch for expanding Ethernet connections', media: ['', '']  },
    { title: 'Power Supply Tester', description: 'Tester for checking power supply functionality', media: ['', '']  },
    { title: 'Cable Tester', description: 'Tester for diagnosing cable issues', media: ['', '']  },
    { title: 'Replacement Laptop Battery', description: 'Battery replacement for laptops', media: ['', '']  },
    { title: 'Battery Charger', description: 'Charger for rechargeable batteries', media: ['', '']  },
    { title: 'Wi-Fi Range Extender', description: 'Device for extending Wi-Fi coverage', media: ['', '']  },
    { title: 'Bluetooth Speaker', description: 'Portable Bluetooth speaker with high sound quality', media: ['', '']  },
    { title: 'USB Printer Cable', description: 'Cable for connecting printers via USB', media: ['', '']  },
    { title: 'Docking Station for Desktop', description: 'Docking station for expanding desktop connectivity', media: ['', '']  },
    { title: 'Power Supply Mounting Brackets', description: 'Brackets for mounting power supplies', media: ['', '']  },
    { title: 'Cable Management Clips', description: 'Clips for securing and organizing cables', media: ['', '']  },
    { title: 'Fan Controller', description: 'Controller for managing case fans', media: ['', '']  },
    { title: 'RGB Lighting Kit', description: 'Kit for adding RGB lighting to your PC', media: ['', '']  },
    { title: 'Computer Mouse Wrist Rest', description: 'Wrist rest for mouse comfort', media: ['', '']  },
    { title: 'Gaming Chair', description: 'Ergonomic chair designed for gamers', media: ['', '']  },
    { title: 'Desktop Organizer', description: 'Organizer for keeping your desk tidy', media: ['', '']  },
    { title: 'Cable Tie Kit', description: 'Kit of cable ties for securing wires', media: ['', '']  },
    { title: 'Power Cable', description: 'Replacement power cable for PCs', media: ['', '']  },
    { title: 'HDMI Cable', description: 'High-speed HDMI cable for video and audio', media: ['', '']  },
    { title: 'DisplayPort Cable', description: 'Cable for connecting monitors via DisplayPort', media: ['', '']  },
    { title: 'VGA Cable', description: 'Cable for connecting monitors via VGA', media: ['', '']  },
    { title: 'DVI Cable', description: 'Cable for connecting monitors via DVI', media: ['', '']  },
    { title: 'Adapter for HDMI to VGA', description: 'Adapter for converting HDMI to VGA', media: ['', '']  },
    { title: 'Adapter for USB to HDMI', description: 'Adapter for connecting USB to HDMI', media: ['', '']  },
    { title: 'Keyboard Cover', description: 'Cover to protect your keyboard from dust and spills', media: ['', '']  },
    { title: 'Laptop Screen Protector', description: 'Protector for preventing scratches on laptop screens', media: ['', '']  },
    { title: 'Screen Cleaning Kit', description: 'Kit for cleaning computer screens', media: ['', '']  },
    { title: 'Portable Power Bank', description: 'Power bank for charging devices on the go', media: ['', '']  },
    { title: 'Multi-Port Charger', description: 'Charger with multiple ports for simultaneous device charging', media: ['', '']  },
    { title: 'Wireless Charging Pad', description: 'Pad for charging devices wirelessly', media: ['', '']  },
    { title: 'USB Hub with SD Card Reader', description: 'USB hub with integrated SD card reader', media: ['', ''] },
    { title: 'Laptop Cooling Stand', description: 'Stand with built-in cooling fans for laptops', media: ['', ''] },
    { title: 'Desk Lamp', description: 'Adjustable desk lamp with LED light', media: ['', ''] },
    { title: 'Cable Management Sleeve', description: 'Sleeve for bundling and organizing cables', media: ['', ''] },
    { title: 'Bluetooth Keyboard', description: 'Bluetooth keyboard for wireless typing', media: ['', ''] },
    { title: 'Bluetooth Mouse', description: 'Bluetooth mouse for wireless use', media: ['', ''] },
    { title: 'Computer Repair Tool Kit', description: 'Kit with tools for repairing computers', media: ['', ''] },
    { title: 'Anti-Static Wrist Strap', description: 'Wrist strap for preventing static discharge', media: ['', ''] },
    { title: 'Heat Gun', description: 'Heat gun for various repair and crafting tasks', media: ['', ''] },
    { title: 'Screwdriver Set with Magnetic Tips', description: 'Magnetic screwdriver set for easy handling', media: ['', ''] },
    { title: 'Precision Tool Kit', description: 'Precision tools for detailed work on electronics', media: ['', ''] },
    { title: 'Electric Soldering Iron', description: 'Soldering iron for electronics repairs', media: ['', ''] },
    { title: 'Desoldering Pump', description: 'Pump for removing solder', media: ['', ''] }
  ]
}

# Define the date range for April
april_range = (Date.new(2024, 4, 1)..Date.new(2024, 4, 30))

# Seed products
category_products.each do |category_name, products|
  # Find the category by name
  category = Category.find_by(name: category_name)
  next unless category
  
  # Fetch all subcategories for this category
  subcategories = category.subcategories
  
  products.each do |product_data|
    # Randomly assign a subcategory
    random_subcategory = subcategories.sample
    
    # Find or create the product
    product = Product.find_or_initialize_by(title: product_data[:title])
    
    if product.new_record?
      # Generate a random date in April
      created_at = Faker::Date.between(from: april_range.begin, to: april_range.end)
      
      product.description = product_data[:description]
      product.category_id = category.id
      product.subcategory_id = random_subcategory.id if random_subcategory.present?
      product.vendor_id = Vendor.all.sample.id
      product.price = Faker::Commerce.price(range: 200..10000)
      product.quantity = Faker::Number.between(from: 30, to: 100)
      product.brand = Faker::Company.name
      product.manufacturer = Faker::Company.name
      product.item_length = Faker::Number.between(from: 10, to: 50)
      product.item_width = Faker::Number.between(from: 10, to: 50)
      product.item_height = Faker::Number.between(from: 10, to: 50)
      product.item_weight = Faker::Number.decimal(l_digits: 1, r_digits: 2)
      product.weight_unit = ['Grams', 'Kilograms'].sample
      product.media = product_data[:media]
      product.created_at = created_at
      product.updated_at = created_at
      product.save!
    end
  end
end




# Define the date range for each month
date_ranges = {
  May: (Date.new(2024, 5, 1)..Date.new(2024, 5, 31)),
  June: (Date.new(2024, 6, 1)..Date.new(2024, 6, 30)),
  July: (Date.new(2024, 7, 1)..Date.new(2024, 7, 31)),
  August: (Date.new(2024, 8, 1)..Date.today) # Up to the current date
}

# Define the date range for each month
date_ranges = {
  May: (Date.new(2024, 5, 1)..Date.new(2024, 5, 31)),
  June: (Date.new(2024, 6, 1)..Date.new(2024, 6, 30)),
  July: (Date.new(2024, 7, 1)..Date.new(2024, 7, 31)),
  August: (Date.new(2024, 8, 1)..Date.today) # Up to the current date
}

# Generate 500 order data hashes
order_data = 500.times.map do
  purchaser = Purchaser.all.sample
  status = ['Processing', 'Dispatched', 'In-Transit', 'Delivered', 'Cancelled', 'Returned'].sample
  total_amount = Faker::Commerce.price(range: 50..500)
  def generate_mpesa_transaction_code
    alpha_part = Faker::Alphanumeric.unique.alpha(number: 7).upcase # Generate 7 alphabetic characters
    random_digits = Faker::Number.number(digits: 3) # Generate 3 random digits
    unique_part = Faker::Alphanumeric.unique.alpha(number: 3).upcase # Generate 3 more alphabetic characters
  
    # Combine parts: insert random_digits after the second character
    "#{alpha_part[0..1]}#{random_digits}#{alpha_part[2..-1]}#{unique_part}"
  end
  
  mpesa_transaction_code = generate_mpesa_transaction_code

  # Randomly select a month and date range
  selected_month = date_ranges.keys.sample
  date_range = date_ranges[selected_month]
  created_at = Faker::Date.between(from: date_range.begin, to: date_range.end)

  {
    purchaser_id: purchaser.id,
    status: status,
    total_amount: total_amount,
    mpesa_transaction_code: mpesa_transaction_code,
    created_at: created_at,
    updated_at: created_at,
    order_items: rand(1..5).times.map do
      product = Product.all.sample
      quantity = Faker::Number.between(from: 1, to: 10)
      price = product.price
      total_price = price * quantity

      {
        product_id: product.id,
        quantity: quantity,
        price: price,
        total_price: total_price,
        vendor_id: product.vendor_id
      }
    end
  }
end

# Sort the order data by created_at date
sorted_order_data = order_data.sort_by { |data| data[:created_at] }

# Create orders in sorted order
sorted_order_data.each do |data|
  order = Order.create!(
    purchaser_id: data[:purchaser_id],
    status: data[:status],
    total_amount: data[:total_amount],
    mpesa_transaction_code: data[:mpesa_transaction_code],
    created_at: data[:created_at],
    updated_at: data[:updated_at]
  )

  # Create order items
  data[:order_items].each do |item_data|
    OrderItem.create!(
      order_id: order.id,
      product_id: item_data[:product_id],
      quantity: item_data[:quantity],
      price: item_data[:price],
      total_price: item_data[:total_price],
      created_at: data[:created_at],
      updated_at: data[:updated_at]
    )

    # Associate the order with a vendor
    OrderVendor.create!(
      order_id: order.id,
      vendor_id: item_data[:vendor_id],
      created_at: data[:created_at],
      updated_at: data[:updated_at]
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

