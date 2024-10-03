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
    { title: 'Water Filter', description: 'High-quality water filter for home use', media: ['', ''] },
    { title: 'Air Purifier Filter', description: 'Filter for air purifiers', media: ['', ''] },
    { title: 'HEPA Filter', description: 'High-efficiency particulate air filter for air purification', media: ['', ''] },
    { title: 'Carbon Filter', description: 'Activated carbon filter for water and air filtration', media: ['', ''] },
    { title: 'Reverse Osmosis Membrane', description: 'RO membrane for advanced water filtration', media: ['', ''] },
    { title: 'UV Water Filter', description: 'UV filter for sterilizing water', media: ['', ''] },
    { title: 'Furnace Filter', description: 'Furnace filter for HVAC systems', media: ['', ''] },
    { title: 'Inline Water Filter', description: 'Inline filter for direct water filtration', media: ['', ''] },
    { title: 'Pre-Filter', description: 'Pre-filter for removing larger particles', media: ['', ''] },
    { title: 'Sediment Filter', description: 'Sediment filter for removing dirt and rust', media: ['', ''] },
    { title: 'Water Softener Filter', description: 'Filter for water softeners', media: ['', ''] },
    { title: 'KDF Filter', description: 'Kinetic degradation fluxion filter for water treatment', media: ['', ''] },
    { title: 'Air Purifier HEPA Filter', description: 'HEPA filter for air purifiers', media: ['', ''] },
    { title: 'Odor Filter', description: 'Filter for removing odors from air', media: ['', ''] },
    { title: 'Bacteria Filter', description: 'Filter for removing bacteria from water', media: ['', ''] },
    { title: 'Chlorine Filter', description: 'Filter for removing chlorine from water', media: ['', ''] },
    { title: 'Chemical Filter', description: 'Filter for removing chemicals from water', media: ['', ''] },
    { title: 'Multi-Stage Water Filter', description: 'Multi-stage filter for comprehensive water purification', media: ['', ''] },
    { title: 'Home Water Filter System', description: 'Complete water filter system for home use', media: ['', ''] },
    { title: 'Commercial Water Filter', description: 'Water filter system for commercial use', media: ['', ''] },
    { title: 'Pool Filter', description: 'Filter for swimming pool water', media: ['', ''] },
    { title: 'Aquarium Filter', description: 'Filter for aquarium water', media: ['', ''] },
    { title: 'Coffee Maker Water Filter', description: 'Filter for coffee makers', media: ['', ''] },
    { title: 'Refrigerator Water Filter', description: 'Filter for refrigerator water dispensers', media: ['', ''] },
    { title: 'Under Sink Water Filter', description: 'Under sink filter for clean drinking water', media: ['', ''] },
    { title: 'Shower Filter', description: 'Filter for removing impurities from shower water', media: ['', ''] },
    { title: 'Whole House Water Filter', description: 'Filter system for treating water for the entire house', media: ['', ''] },
    { title: 'Drinking Water Filter', description: 'Filter designed specifically for drinking water', media: ['', ''] },
    { title: 'Ice Maker Water Filter', description: 'Filter for ice maker water', media: ['', ''] },
    { title: 'Whole House Carbon Filter', description: 'Carbon filter for whole house water filtration', media: ['', ''] },
    { title: 'Whole House Sediment Filter', description: 'Sediment filter for whole house water filtration', media: ['', ''] },
    { title: 'Whole House UV Filter', description: 'UV filter for whole house water treatment', media: ['', ''] },
    { title: 'Inline Carbon Filter', description: 'Inline carbon filter for water treatment', media: ['', ''] },
    { title: 'Inline Sediment Filter', description: 'Inline sediment filter for water treatment', media: ['', ''] },
    { title: 'Inline HEPA Filter', description: 'Inline HEPA filter for air purification', media: ['', ''] },
    { title: 'Air Purifier Carbon Filter', description: 'Carbon filter for air purifiers', media: ['', ''] },
    { title: 'Central Air Filter', description: 'Filter for central air systems', media: ['', ''] },
    { title: 'Washable Air Filter', description: 'Reusable and washable air filter', media: ['', ''] },
    { title: 'Disposable Air Filter', description: 'Disposable filter for air purification', media: ['', ''] },
    { title: 'HEPA Air Filter', description: 'HEPA filter for air purification', media: ['', ''] },
    { title: 'Room Air Filter', description: 'Filter designed for room air purifiers', media: ['', ''] },
    { title: 'Whole House Air Filter', description: 'Air filter system for the entire house', media: ['', ''] },
    { title: 'Air Purifier HEPA Filter Replacement', description: 'Replacement HEPA filter for air purifiers', media: ['', ''] },
    { title: 'Air Purifier Carbon Filter Replacement', description: 'Replacement carbon filter for air purifiers', media: ['', ''] },
    { title: 'Air Purifier Pre-Filter', description: 'Pre-filter for air purifiers', media: ['', ''] },
    { title: 'Ozone Filter', description: 'Filter for removing ozone from air', media: ['', ''] },
    { title: 'Electrostatic Filter', description: 'Electrostatic filter for air purification', media: ['', ''] },
    { title: 'High Efficiency Air Filter', description: 'High-efficiency air filter for HVAC systems', media: ['', ''] },
    { title: 'Anti-Allergen Filter', description: 'Filter designed to reduce allergens in the air', media: ['', ''] },
    { title: 'Anti-Microbial Filter', description: 'Filter with anti-microbial properties for air purification', media: ['', ''] },
    { title: 'Dehumidifier Filter', description: 'Filter for dehumidifiers', media: ['', ''] },
    { title: 'Ventilation Filter', description: 'Filter for ventilation systems', media: ['', ''] },
  { title: 'Car Air Filter', description: 'Air filter for vehicles', media: ['', ''] },
  { title: 'Cabin Air Filter', description: 'Filter for the cabin air of vehicles', media: ['', ''] },
  { title: 'Automotive HEPA Filter', description: 'HEPA filter for vehicles', media: ['', ''] },
  { title: 'Automotive Carbon Filter', description: 'Carbon filter for vehicles', media: ['', ''] },
  { title: 'Automotive Cabin Filter', description: 'Cabin filter for automotive air purification', media: ['', ''] },
  { title: 'Engine Air Filter', description: 'Air filter for engines', media: ['', ''] },
  { title: 'Fuel Filter', description: 'Filter for removing impurities from fuel', media: ['', ''] },
  { title: 'Transmission Filter', description: 'Filter for transmission fluid', media: ['', ''] },
  { title: 'Oil Filter', description: 'Filter for engine oil', media: ['', ''] },
  { title: 'Automatic Transmission Filter', description: 'Filter for automatic transmission fluid', media: ['', ''] },
  { title: 'Hydraulic Filter', description: 'Filter for hydraulic systems', media: ['', ''] },
  { title: 'Industrial Air Filter', description: 'Air filter for industrial applications', media: ['', ''] },
  { title: 'Industrial Water Filter', description: 'Water filter for industrial applications', media: ['', ''] },
  { title: 'Commercial Air Filter', description: 'Air filter for commercial settings', media: ['', ''] },
  { title: 'Commercial Water Filter', description: 'Water filter for commercial settings', media: ['', ''] },
  { title: 'Large Capacity Air Filter', description: 'High-capacity air filter for large spaces', media: ['', ''] },
  { title: 'Large Capacity Water Filter', description: 'High-capacity water filter for large systems', media: ['', ''] },
  { title: 'Portable Water Filter', description: 'Portable filter for on-the-go water purification', media: ['', ''] },
  { title: 'Portable Air Filter', description: 'Portable air filter for mobile use', media: ['', ''] },
  { title: 'Desk Air Filter', description: 'Compact air filter for desk use', media: ['', ''] },
  { title: 'Air Filter Replacement', description: 'Replacement filter for air purifiers', media: ['', ''] },
  { title: 'Water Filter Cartridge', description: 'Cartridge for water filtration systems', media: ['', ''] },
  { title: 'Coffee Maker Water Filter Cartridge', description: 'Replacement cartridge for coffee maker water filters', media: ['', ''] },
  { title: 'Refrigerator Water Filter Cartridge', description: 'Cartridge for refrigerator water filters', media: ['', ''] },
  { title: 'Under Sink Filter Cartridge', description: 'Cartridge for under sink water filters', media: ['', ''] },
  { title: 'Shower Filter Cartridge', description: 'Cartridge for shower water filters', media: ['', ''] },
  { title: 'Whole House Filter Cartridge', description: 'Cartridge for whole house water filters', media: ['', ''] },
  { title: 'Pool Filter Cartridge', description: 'Cartridge for swimming pool filters', media: ['', ''] },
  { title: 'Aquarium Filter Cartridge', description: 'Cartridge for aquarium filters', media: ['', ''] },
  { title: 'Industrial Water Filter Cartridge', description: 'Cartridge for industrial water filters', media: ['', ''] },
  { title: 'Commercial Water Filter Cartridge', description: 'Cartridge for commercial water filters', media: ['', ''] },
  { title: 'Sediment Filter Cartridge', description: 'Cartridge for sediment filters', media: ['', ''] },
  { title: 'Carbon Block Filter', description: 'Carbon block filter for water purification', media: ['', ''] },
  { title: 'Activated Carbon Filter', description: 'Activated carbon filter for water and air', media: ['', ''] },
  { title: 'Ceramic Water Filter', description: 'Ceramic filter for water purification', media: ['', ''] },
  { title: 'Titanium Water Filter', description: 'Titanium filter for advanced water filtration', media: ['', ''] },
  { title: 'Stainless Steel Filter', description: 'Stainless steel filter for various applications', media: ['', ''] },
  { title: 'Stainless Steel Water Filter', description: 'Stainless steel filter for water purification', media: ['', ''] },
  { title: 'Sediment Removal Filter', description: 'Filter for removing sediment from water', media: ['', ''] },
  { title: 'Pre-Carbon Filter', description: 'Pre-filter with carbon for water filtration', media: ['', ''] },
  { title: 'Bio Filter', description: 'Bio filter for biological water treatment', media: ['', ''] },
  { title: 'Iron Removal Filter', description: 'Filter for removing iron from water', media: ['', ''] },
  { title: 'Manganese Removal Filter', description: 'Filter for removing manganese from water', media: ['', ''] },
  { title: 'Copper Removal Filter', description: 'Filter for removing copper from water', media: ['', ''] },
  { title: 'Nitrate Removal Filter', description: 'Filter for removing nitrates from water', media: ['', ''] },
  { title: 'Lead Removal Filter', description: 'Filter for removing lead from water', media: ['', ''] },
  { title: 'PFAS Removal Filter', description: 'Filter for removing PFAS from water', media: ['', ''] },
  { title: 'Arsenic Removal Filter', description: 'Filter for removing arsenic from water', media: ['', ''] },
  { title: 'Radon Removal Filter', description: 'Filter for removing radon from water', media: ['', ''] },
  { title: 'Fluoride Removal Filter', description: 'Filter for removing fluoride from water', media: ['', ''] },
  { title: 'Heavy Metal Removal Filter', description: 'Filter for removing heavy metals from water', media: ['', ''] },
  { title: 'Tannin Removal Filter', description: 'Filter for removing tannins from water', media: ['', ''] },
  { title: 'VOC Removal Filter', description: 'Filter for removing volatile organic compounds from water', media: ['', ''] },
  { title: 'Sulfur Removal Filter', description: 'Filter for removing sulfur from water', media: ['', ''] },
  { title: 'Water Descaler Filter', description: 'Filter for water descaling', media: ['', ''] },
  { title: 'Limescale Removal Filter', description: 'Filter for removing limescale from water', media: ['', ''] },
  { title: 'Magnesium Removal Filter', description: 'Filter for removing magnesium from water', media: ['', ''] },
  { title: 'Calcium Removal Filter', description: 'Filter for removing calcium from water', media: ['', ''] },
  { title: 'Potassium Removal Filter', description: 'Filter for removing potassium from water', media: ['', ''] },
  { title: 'Aluminum Removal Filter', description: 'Filter for removing aluminum from water', media: ['', ''] },
  { title: 'Uranium Removal Filter', description: 'Filter for removing uranium from water', media: ['', ''] },
  { title: 'Chloramine Removal Filter', description: 'Filter for removing chloramine from water', media: ['', ''] },
  { title: 'Zinc Removal Filter', description: 'Filter for removing zinc from water', media: ['', ''] },
  { title: 'Chromium Removal Filter', description: 'Filter for removing chromium from water', media: ['', ''] },
  { title: 'Mercury Removal Filter', description: 'Filter for removing mercury from water', media: ['', ''] },
  { title: 'Cadmium Removal Filter', description: 'Filter for removing cadmium from water', media: ['', ''] },
  { title: 'Nickel Removal Filter', description: 'Filter for removing nickel from water', media: ['', ''] },
  { title: 'Silver Removal Filter', description: 'Filter for removing silver from water', media: ['', ''] },
  { title: 'Gold Removal Filter', description: 'Filter for removing gold from water', media: ['', ''] },
  { title: 'Boron Removal Filter', description: 'Filter for removing boron from water', media: ['', ''] },
  { title: 'Cyanide Removal Filter', description: 'Filter for removing cyanide from water', media: ['', ''] },
  { title: 'PCB Removal Filter', description: 'Filter for removing PCBs from water', media: ['', ''] },
  { title: 'Pesticide Removal Filter', description: 'Filter for removing pesticides from water', media: ['', ''] },
  { title: 'Herbicide Removal Filter', description: 'Filter for removing herbicides from water', media: ['', ''] },
  { title: 'Pharmaceutical Removal Filter', description: 'Filter for removing pharmaceuticals from water', media: ['', ''] },
  { title: 'Hormone Removal Filter', description: 'Filter for removing hormones from water', media: ['', ''] },
  { title: 'Virus Removal Filter', description: 'Filter for removing viruses from water', media: ['', ''] },
  { title: 'Pathogen Removal Filter', description: 'Filter for removing pathogens from water', media: ['', ''] },
  { title: 'Protozoa Removal Filter', description: 'Filter for removing protozoa from water', media: ['', ''] },
  { title: 'Cyst Removal Filter', description: 'Filter for removing cysts from water', media: ['', ''] },
  { title: 'Giardia Removal Filter', description: 'Filter for removing Giardia from water', media: ['', ''] },
  { title: 'Cryptosporidium Removal Filter', description: 'Filter for removing Cryptosporidium from water', media: ['', ''] },
  { title: 'Algae Removal Filter', description: 'Filter for removing algae from water', media: ['', ''] },
  { title: 'Biofilm Removal Filter', description: 'Filter for removing biofilm from water', media: ['', ''] },
  { title: 'Slime Removal Filter', description: 'Filter for removing slime from water', media: ['', ''] },
  { title: 'Microbial Removal Filter', description: 'Filter for removing microbes from water', media: ['', ''] },
  { title: 'Bacterial Removal Filter', description: 'Filter for removing bacteria from water', media: ['', ''] },
  { title: 'Viral Removal Filter', description: 'Filter for removing viruses from water', media: ['', ''] },
  { title: 'Pathogen Removal Filter', description: 'Filter for removing pathogens from water', media: ['', ''] },
  { title: 'Radiological Removal Filter', description: 'Filter for removing radiological contaminants from water', media: ['', ''] },
  { title: 'Organic Removal Filter', description: 'Filter for removing organic contaminants from water', media: ['', ''] },
  { title: 'Inorganic Removal Filter', description: 'Filter for removing inorganic contaminants from water', media: ['', ''] },
  { title: 'Particle Removal Filter', description: 'Filter for removing particles from water', media: ['', ''] },
  { title: 'Dirt Removal Filter', description: 'Filter for removing dirt from water', media: ['', ''] },
  { title: 'Sand Removal Filter', description: 'Filter for removing sand from water', media: ['', ''] }
],

'Hardware Tools' => [
  { title: 'Hammer', description: 'Durable hammer for various tasks', media: ['', ''] },
  { title: 'Screwdriver Set', description: 'Set of screwdrivers with various heads', media: ['', ''] },
  { title: 'Adjustable Wrench', description: 'Versatile wrench for multiple applications', media: ['', ''] },
  { title: 'Cordless Drill', description: 'High-performance cordless drill with battery', media: ['', ''] },
  { title: 'Tape Measure', description: 'Reliable tape measure for accurate measurements', media: ['', ''] },
  { title: 'Utility Knife', description: 'Sharp utility knife for cutting tasks', media: ['', ''] },
  { title: 'Pliers Set', description: 'Set of pliers for gripping and cutting', media: ['', ''] },
  { title: 'Level', description: 'Precision level for ensuring accurate alignment', media: ['', ''] },
  { title: 'Circular Saw', description: 'Powerful circular saw for cutting wood and other materials', media: ['', ''] },
  { title: 'Chisel Set', description: 'Set of chisels for woodworking and carving', media: ['', ''] },
  { title: 'Socket Wrench Set', description: 'Comprehensive socket wrench set for automotive work', media: ['', ''] },
  { title: 'Allen Wrench Set', description: 'Hex key set for assembling furniture and equipment', media: ['', ''] },
  { title: 'Claw Hammer', description: 'Heavy-duty claw hammer for construction tasks', media: ['', ''] },
  { title: 'Rubber Mallet', description: 'Soft rubber mallet for gentle striking', media: ['', ''] },
  { title: 'Hacksaw', description: 'Adjustable hacksaw for cutting metal and plastic', media: ['', ''] },
  { title: 'Handsaw', description: 'Sharp handsaw for precise cutting of wood', media: ['', ''] },
  { title: 'Jigsaw', description: 'Electric jigsaw for curved and intricate cuts', media: ['', ''] },
  { title: 'Sledgehammer', description: 'Heavy sledgehammer for demolition work', media: ['', ''] },
  { title: 'Pipe Wrench', description: 'Adjustable pipe wrench for plumbing tasks', media: ['', ''] },
  { title: 'Needle-Nose Pliers', description: 'Long-nose pliers for reaching tight spaces', media: ['', ''] },
  { title: 'Vise Grip Pliers', description: 'Locking pliers with adjustable grip', media: ['', ''] },
  { title: 'Crescent Wrench', description: 'Adjustable crescent wrench for various nuts and bolts', media: ['', ''] },
  { title: 'Tin Snips', description: 'Sharp tin snips for cutting sheet metal', media: ['', ''] },
  { title: 'Wire Strippers', description: 'Precision wire strippers for electrical work', media: ['', ''] },
  { title: 'Bolt Cutters', description: 'Heavy-duty bolt cutters for cutting metal rods and chains', media: ['', ''] },
  { title: 'Staple Gun', description: 'Manual staple gun for fastening materials', media: ['', ''] },
  { title: 'Impact Driver', description: 'High-torque impact driver for driving screws and bolts', media: ['', ''] },
  { title: 'Angle Grinder', description: 'Powerful angle grinder for grinding and cutting', media: ['', ''] },
  { title: 'Table Saw', description: 'Large table saw for woodworking projects', media: ['', ''] },
  { title: 'Miter Saw', description: 'Precision miter saw for angled cuts', media: ['', ''] },
  { title: 'Rotary Tool', description: 'Versatile rotary tool for sanding, cutting, and engraving', media: ['', ''] },
  { title: 'Heat Gun', description: 'Adjustable heat gun for stripping paint and other tasks', media: ['', ''] },
  { title: 'Soldering Iron', description: 'Electric soldering iron for electronic repairs', media: ['', ''] },
  { title: 'Combination Square', description: 'Multi-purpose combination square for measuring and marking', media: ['', ''] },
  { title: 'Carpenters Pencil', description: 'Durable pencil for marking wood and other materials', media: ['', ''] },
  { title: 'C-Clamps', description: 'Strong C-clamps for holding materials in place', media: ['', ''] },
  { title: 'Bar Clamps', description: 'Adjustable bar clamps for woodworking and assembly', media: ['', ''] },
  { title: 'G-Clamps', description: 'Heavy-duty G-clamps for securing workpieces', media: ['', ''] },
  { title: 'Wood Rasp', description: 'Coarse wood rasp for shaping and smoothing wood', media: ['', ''] },
  { title: 'Flat File', description: 'Flat file for smoothing metal and other materials', media: ['', ''] },
  { title: 'Round File', description: 'Round file for enlarging holes and shaping curves', media: ['', ''] },
  { title: 'Sandpaper Assortment', description: 'Variety pack of sandpaper for different grits', media: ['', ''] },
  { title: 'Workbench', description: 'Sturdy workbench for all your projects', media: ['', ''] },
  { title: 'Toolbox', description: 'Portable toolbox for organizing tools', media: ['', ''] },
  { title: 'Tool Belt', description: 'Convenient tool belt for carrying essentials', media: ['', ''] },
  { title: 'Safety Goggles', description: 'Protective safety goggles for eye protection', media: ['', ''] },
  { title: 'Ear Protection', description: 'Noise-cancelling ear protection for loud environments', media: ['', ''] },
  { title: 'Work Gloves', description: 'Durable work gloves for hand protection', media: ['', ''] },
  { title: 'Knee Pads', description: 'Comfortable knee pads for extended work', media: ['', ''] },
  { title: 'Dust Mask', description: 'Breathable dust mask for protection from particles', media: ['', ''] },
  { title: 'Hard Hat', description: 'Impact-resistant hard hat for head protection', media: ['', ''] },
  { title: 'Respirator', description: 'Advanced respirator for protection from fumes and dust', media: ['', ''] },
  { title: 'Utility Apron', description: 'Heavy-duty utility apron with multiple pockets', media: ['', ''] },
  { title: 'Extension Cord', description: 'Long extension cord for powering tools at a distance', media: ['', ''] },
  { title: 'Work Light', description: 'Bright work light for illuminating your workspace', media: ['', ''] },
  { title: 'Ladder', description: 'Sturdy ladder for reaching high places', media: ['', ''] },
  { title: 'Step Stool', description: 'Compact step stool for easy access to elevated areas', media: ['', ''] },
  { title: 'Extension Ladder', description: 'Adjustable extension ladder for extended reach', media: ['', ''] },
  { title: 'Sawhorse', description: 'Durable sawhorse for supporting workpieces', media: ['', ''] },
  { title: 'Folding Workbench', description: 'Portable folding workbench for on-the-go projects', media: ['', ''] },
  { title: 'Tool Organizer', description: 'Wall-mounted tool organizer for easy access', media: ['', ''] },
  { title: 'Magnetic Tool Holder', description: 'Magnetic tool holder for quick storage', media: ['', ''] },
  { title: 'Tool Chest', description: 'Large tool chest for comprehensive tool storage', media: ['', ''] },
  { title: 'Drill Bit Set', description: 'Assorted drill bit set for various materials', media: ['', ''] },
  { title: 'Hole Saw Kit', description: 'Complete hole saw kit for cutting large holes', media: ['', ''] },
  { title: 'Wood Router', description: 'Powerful wood router for shaping and trimming', media: ['', ''] },
  { title: 'Belt Sander', description: 'Electric belt sander for smoothing surfaces', media: ['', ''] },
  { title: 'Orbital Sander', description: 'Random orbital sander for a smooth finish', media: ['', ''] },
  { title: 'Palm Sander', description: 'Compact palm sander for detailed work', media: ['', ''] },
  { title: 'Bench Grinder', description: 'Sturdy bench grinder for sharpening tools', media: ['', ''] },
  { title: 'Chop Saw', description: 'Heavy-duty chop saw for cutting metal and wood', media: ['', ''] },
  { title: 'Reciprocating Saw', description: 'Versatile reciprocating saw for demolition work', media: ['', ''] },
  { title: 'Planer', description: 'Electric planer for smoothing and leveling wood', media: ['', ''] },
  { title: 'Nail Gun', description: 'Pneumatic nail gun for fast and efficient nailing', media: ['', ''] },
  { title: 'Staple Gun', description: 'Electric staple gun for upholstery and crafts', media: ['', ''] },
  { title: 'Brad Nailer', description: 'Precision brad nailer for trim work', media: ['', ''] },
  { title: 'Finish Nailer', description: 'Finish nailer for carpentry and finishing tasks', media: ['', ''] },
  { title: 'Palm Nailer', description: 'Compact palm nailer for tight spaces', media: ['', ''] },
  { title: 'Air Compressor', description: 'Portable air compressor for powering pneumatic tools', media: ['', ''] },
  { title: 'Air Hose', description: 'Flexible air hose for connecting pneumatic tools', media: ['', ''] },
  { title: 'Air Tool Kit', description: 'Complete air tool kit for various applications', media: ['', ''] },
  { title: 'Shop Vacuum', description: 'Powerful shop vacuum for cleaning up debris', media: ['', ''] },
  { title: 'Dust Collector', description: 'Efficient dust collector for woodworking shops', media: ['', ''] },
  { title: 'Blower', description: 'Electric blower for clearing leaves and debris', media: ['', ''] },
  { title: 'Pressure Washer', description: 'High-pressure washer for cleaning surfaces', media: ['', ''] },
  { title: 'Power Washer', description: 'Gas-powered washer for heavy-duty cleaning', media: ['', ''] },
  { title: 'Paint Sprayer', description: 'Electric paint sprayer for smooth and even coverage', media: ['', ''] },
  { title: 'Caulking Gun', description: 'Manual caulking gun for sealing joints', media: ['', ''] },
  { title: 'Putty Knife', description: 'Flexible putty knife for spreading and scraping', media: ['', ''] },
  { title: 'Painters Tape', description: 'High-quality painters tape for clean lines', media: ['', ''] },
  { title: 'Paint Roller', description: 'Durable paint roller for even application', media: ['', ''] },
  { title: 'Paint Tray', description: 'Sturdy paint tray for holding paint and rollers', media: ['', ''] },
  { title: 'Paintbrush Set', description: 'Set of paintbrushes for detailed painting', media: ['', ''] },
  { title: 'Drop Cloth', description: 'Protective drop cloth for covering surfaces', media: ['', ''] },
  { title: 'Lawn Mower', description: 'Gas-powered lawn mower for cutting grass', media: ['', ''] },
  { title: 'Electric Lawn Mower', description: 'Eco-friendly electric lawn mower', media: ['', ''] },
  { title: 'String Trimmer', description: 'Cordless string trimmer for edging and trimming', media: ['', ''] },
  { title: 'Hedge Trimmer', description: 'Electric hedge trimmer for shaping bushes', media: ['', ''] },
  { title: 'Leaf Blower', description: 'High-speed leaf blower for clearing debris', media: ['', ''] },
  { title: 'Chainsaw', description: 'Powerful chainsaw for cutting trees and branches', media: ['', ''] },
  { title: 'Garden Shovel', description: 'Heavy-duty garden shovel for digging', media: ['', ''] },
  { title: 'Garden Hoe', description: 'Durable garden hoe for tilling soil', media: ['', ''] },
  { title: 'Garden Rake', description: 'Sturdy garden rake for clearing leaves', media: ['', ''] },
  { title: 'Pruning Shears', description: 'Sharp pruning shears for trimming plants', media: ['', ''] },
  { title: 'Loppers', description: 'Heavy-duty loppers for cutting thick branches', media: ['', ''] },
  { title: 'Wheelbarrow', description: 'Robust wheelbarrow for transporting materials', media: ['', ''] },
  { title: 'Garden Hose', description: 'Flexible garden hose for watering plants', media: ['', ''] },
  { title: 'Hose Reel', description: 'Convenient hose reel for easy storage', media: ['', ''] },
  { title: 'Watering Can', description: 'Classic watering can for precise watering', media: ['', ''] },
  { title: 'Sprinkler', description: 'Automatic sprinkler for lawn irrigation', media: ['', ''] },
  { title: 'Garden Trowel', description: 'Handy garden trowel for planting and digging', media: ['', ''] },
  { title: 'Weed Puller', description: 'Ergonomic weed puller for removing weeds', media: ['', ''] },
  { title: 'Garden Fork', description: 'Durable garden fork for turning soil', media: ['', ''] },
  { title: 'Post Hole Digger', description: 'Manual post hole digger for fence installation', media: ['', ''] },
  { title: 'Garden Cart', description: 'Heavy-duty garden cart for transporting tools', media: ['', ''] },
  { title: 'Cultivator', description: 'Hand cultivator for aerating soil', media: ['', ''] },
  { title: 'Garden Kneeler', description: 'Padded garden kneeler for comfortable gardening', media: ['', ''] },
  { title: 'Compost Bin', description: 'Large compost bin for organic waste', media: ['', ''] },
  { title: 'Soil Tester', description: 'Soil tester for measuring pH and nutrient levels', media: ['', ''] },
  { title: 'Pruning Saw', description: 'Compact pruning saw for cutting branches', media: ['', ''] },
  { title: 'Garden Sprayer', description: 'Pressure garden sprayer for applying treatments', media: ['', ''] },
  { title: 'Water Timer', description: 'Automatic water timer for irrigation control', media: ['', ''] },
  { title: 'Mulch', description: 'High-quality mulch for garden beds', media: ['', ''] },
  { title: 'Garden Edging', description: 'Decorative garden edging for borders', media: ['', ''] },
  { title: 'Fence Pliers', description: 'Multi-purpose fence pliers for installation and repair', media: ['', ''] },
  { title: 'Wire Cutters', description: 'Heavy-duty wire cutters for cutting fencing', media: ['', ''] },
  { title: 'Bolt Fasteners', description: 'Assorted bolt fasteners for various applications', media: ['', ''] },
  { title: 'Nails Assortment', description: 'Variety pack of nails for different projects', media: ['', ''] },
  { title: 'Screws Assortment', description: 'Assorted screws for wood, metal, and drywall', media: ['', ''] },
  { title: 'Anchors Assortment', description: 'Complete anchor set for securing to walls', media: ['', ''] }
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
  { title: 'Power Steering Pulley', description: 'Pulley for driving the power steering pump', media: ['', '']   },
  { title: 'Timing Belt Tensioners', description: 'Tensioners for timing belts', media: ['', '']   },
  { title: 'Timing Chain Tensioners', description: 'Tensioners for timing chains', media: ['', '']   },
  { title: 'Accessory Drive Belts', description: 'Belts for driving engine accessories', media: ['', '']   },
  { title: 'Serpentine Belts', description: 'Belts for driving multiple accessories', media: ['', '']   },
  { title: 'Fuel Pressure Regulators', description: 'Regulators for controlling fuel pressure', media: ['', '']   },
  { title: 'Oil Pressure Switches', description: 'Switches for monitoring oil pressure', media: ['', '']   },
  { title: 'Coolant Temperature Sensors', description: 'Sensors for monitoring coolant temperature', media: ['', '']   },
  { title: 'Throttle Position Sensors', description: 'Sensors for monitoring throttle position', media: ['', '']   },
  { title: 'Mass Air Flow Sensors', description: 'Sensors for measuring air flow into the engine', media: ['', '']   },
  { title: 'Camshaft Sensors', description: 'Sensors for monitoring camshaft position', media: ['', '']   },
  { title: 'Crankshaft Sensors', description: 'Sensors for monitoring crankshaft position', media: ['', '']   },
  { title: 'Vehicle Speed Sensors', description: 'Sensors for measuring vehicle speed', media: ['', '']   },
  { title: 'ABS Sensors', description: 'Sensors for anti-lock braking systems', media: ['', '']   },
  { title: 'TPMS Sensors', description: 'Sensors for monitoring tire pressure', media: ['', '']   },
  { title: 'Oxygen Sensor Socket', description: 'Socket for removing oxygen sensors', media: ['', '']   },
  { title: 'Spark Plug Socket', description: 'Socket for removing spark plugs', media: ['', '']   },
  { title: 'Glow Plugs', description: 'Plugs for warming diesel engine cylinders', media: ['', '']   },
  { title: 'Injector Nozzles', description: 'Nozzles for fuel injectors', media: ['', '']   },
  { title: 'Fuel Tank Straps', description: 'Straps for securing the fuel tank', media: ['', '']   },
  { title: 'Fuel Pump Relays', description: 'Relays for operating the fuel pump', media: ['', '']   },
  { title: 'Fuse Boxes', description: 'Boxes for housing electrical fuses', media: ['', '']   },
  { title: 'Wiring Harnesses', description: 'Harnesses for electrical wiring', media: ['', '']   },
  { title: 'Battery Cables', description: 'Cables for connecting the car battery', media: ['', '']   },
  { title: 'Starter Solenoids', description: 'Solenoids for operating the starter motor', media: ['', '']   },
  { title: 'Alternator Regulators', description: 'Regulators for controlling alternator output', media: ['', '']   },
  { title: 'Voltage Regulators', description: 'Regulators for controlling electrical voltage', media: ['', '']   },
  { title: 'Headlight Bulbs', description: 'Bulbs for headlights', media: ['', '']   },
  { title: 'Tail Light Bulbs', description: 'Bulbs for tail lights', media: ['', '']   },
  { title: 'Fog Light Bulbs', description: 'Bulbs for fog lights', media: ['', '']   },
  { title: 'Turn Signal Bulbs', description: 'Bulbs for turn signals', media: ['', '']   },
  { title: 'Interior Light Bulbs', description: 'Bulbs for interior lighting', media: ['', '']   },
  { title: 'License Plate Lights', description: 'Lights for illuminating license plates', media: ['', '']   },
  { title: 'Hood Struts', description: 'Struts for holding up the hood', media: ['', '']   },
  { title: 'Trunk Struts', description: 'Struts for holding up the trunk', media: ['', '']   },
  { title: 'Door Handles', description: 'Handles for opening vehicle doors', media: ['', '']   },
  { title: 'Window Regulators', description: 'Regulators for operating window movement', media: ['', '']   },
  { title: 'Mirror Assemblies', description: 'Assemblies for side mirrors', media: ['', '']   },
  { title: 'Door Panels', description: 'Panels for vehicle doors', media: ['', '']   },
  { title: 'Carpet Kits', description: 'Kits for replacing vehicle carpets', media: ['', '']   },
  { title: 'Seat Covers', description: 'Covers for vehicle seats', media: ['', '']  },
  { title: 'Floor Mats', description: 'Mats for protecting vehicle floors', media: ['', '']  },
  { title: 'Dashboard Covers', description: 'Covers for protecting dashboards', media: ['', '']  },
  { title: 'Sun Visors', description: 'Visors for blocking sunlight', media: ['', '']  },
  { title: 'Steering Wheels', description: 'Wheels for steering the vehicle', media: ['', '']  },
  { title: 'Gear Shift Knobs', description: 'Knobs for shifting gears', media: ['', '']  },
  { title: 'Pedal Covers', description: 'Covers for vehicle pedals', media: ['', '']  },
  { title: 'Horn Kits', description: 'Kits for installing vehicle horns', media: ['', '']  },
  { title: 'Wiper Arms', description: 'Arms for holding windshield wipers', media: ['', '']  }
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
  { title: 'Desoldering Pump', description: 'Pump for removing solder', media: ['', ''] },
  { title: 'High-Capacity USB-C Power Bank', description: 'USB-C power bank with high capacity for extended usage', media: ['', ''] },
  { title: 'Portable External Drive with High-Speed Data Transfer', description: 'External drive with high-speed data transfer rates', media: ['', ''] },
  { title: 'USB-C to DisplayPort Adapter with 4K Support', description: 'Adapter for connecting USB-C to DisplayPort with 4K resolution support', media: ['', ''] },
  { title: 'Smart Home Security System with Motion Detection', description: 'Security system with motion detection capabilities', media: ['', ''] },
  { title: 'Portable Power Bank with Built-In Cables', description: 'Power bank with built-in cables for convenience', media: ['', ''] },
  { title: 'High-Speed USB-C Charging Hub with Multiple Ports', description: 'USB-C charging hub with multiple ports and high-speed charging', media: ['', ''] },
  { title: 'Adjustable Desk with Wireless Charging', description: 'Desk with built-in wireless charging pad', media: ['', ''] },
  { title: 'Portable External SSD with Shockproof Design', description: 'External SSD with shockproof design for durability', media: ['', ''] },
  { title: 'Smart Home Controller with Voice Assistance', description: 'Home controller with voice assistance for smart devices', media: ['', ''] },
  { title: 'USB-C to Mini DisplayPort Adapter with 4K Support', description: 'Adapter for connecting USB-C to Mini DisplayPort with 4K support', media: ['', ''] },
  { title: 'High-Speed External Hard Drive with Encryption', description: 'External hard drive with high-speed data transfer and encryption', media: ['', ''] },
  { title: 'Adjustable Monitor Mount with Cable Management', description: 'Monitor mount with adjustable height and cable management', media: ['', ''] },
  { title: 'Smart Thermostat with Remote Control', description: 'Thermostat with remote control features for smart climate management', media: ['', ''] },
  { title: 'Portable External Hard Drive with Built-In Encryption', description: 'External hard drive with built-in encryption for data security', media: ['', ''] },
  { title: 'USB-C to Thunderbolt 4 Adapter', description: 'Adapter for connecting USB-C devices to Thunderbolt 4 ports', media: ['', ''] },
  { title: 'High-Speed USB-C Hub with 8K Support', description: 'USB-C hub with support for 8K video output', media: ['', ''] },
  { title: 'Adjustable Laptop Desk with Built-In Charging Ports', description: 'Laptop desk with built-in charging ports and cable management', media: ['', ''] }
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

