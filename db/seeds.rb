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
  { name: 'Filtration Solutions', description: 'Products related to filtration solutions' },
  { name: 'Hardware Tools & Equipment', description: 'Various Hardware Tools' }
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
      { name: 'Lubrication' },
      { name: 'Mechanical Tools' },
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
      { name: 'Storage Solutions' },
      { name: 'Others' }
    ]
  when 'Filtration Solutions'
    subcategories = [
      { name: 'Air Filters' },
      { name: 'Fuel Filters' },
      { name: 'Industrial Ventilation Filters' },
      { name: 'Oil & Hydraulic Filters' },
      { name: 'Specialised Filtration Solutions' },
      { name: 'Others' }
    ]
  when 'Hardware Tools & Equipment'
    subcategories = [
      { name: 'Building Materials' },
      { name: 'Cleaning Supplies' },
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
  end
end


# Seed vendors data
100.times do
  Vendor.find_or_create_by(email: nil) do |vendor|
    fullname = Faker::Name.name
    email = "#{fullname.downcase.gsub(/\s+/, "")}@example.com"

    vendor.fullname = fullname
    vendor.email = email
    vendor.phone_number = generate_custom_phone_number(used_phone_numbers)
    used_phone_numbers.add(vendor.phone_number)
    vendor.enterprise_name = "#{Faker::Company.name} #{Faker::Company.suffix}"
    vendor.location = Faker::Address.full_address
    vendor.password = 'password'
    vendor.business_registration_number = "BN/#{Faker::Number.number(digits: 4)}/#{Faker::Number.number(digits: 6)}"
    vendor.category_ids = [Category.all.sample.id]
  end
end







category_products = {
  'Filtration Solutions' => [
  { title: 'Water Filter', description: 'High-quality water filter for home use' },
  { title: 'Air Purifier Filter', description: 'Filter for air purifiers' },
  { title: 'HEPA Filter', description: 'High-efficiency particulate air filter for air purification' },
  { title: 'Carbon Filter', description: 'Activated carbon filter for water and air filtration' },
  { title: 'Reverse Osmosis Membrane', description: 'RO membrane for advanced water filtration' },
  { title: 'UV Water Filter', description: 'UV filter for sterilizing water' },
  { title: 'Furnace Filter', description: 'Furnace filter for HVAC systems' },
  { title: 'Inline Water Filter', description: 'Inline filter for direct water filtration' },
  { title: 'Pre-Filter', description: 'Pre-filter for removing larger particles' },
  { title: 'Sediment Filter', description: 'Sediment filter for removing dirt and rust' },
  { title: 'Water Softener Filter', description: 'Filter for water softeners' },
  { title: 'KDF Filter', description: 'Kinetic degradation fluxion filter for water treatment' },
  { title: 'Air Purifier HEPA Filter', description: 'HEPA filter for air purifiers' },
  { title: 'Odor Filter', description: 'Filter for removing odors from air' },
  { title: 'Bacteria Filter', description: 'Filter for removing bacteria from water' },
  { title: 'Chlorine Filter', description: 'Filter for removing chlorine from water' },
  { title: 'Chemical Filter', description: 'Filter for removing chemicals from water' },
  { title: 'Multi-Stage Water Filter', description: 'Multi-stage filter for comprehensive water purification' },
  { title: 'Home Water Filter System', description: 'Complete water filter system for home use' },
  { title: 'Commercial Water Filter', description: 'Water filter system for commercial use' },
  { title: 'Pool Filter', description: 'Filter for swimming pool water' },
  { title: 'Aquarium Filter', description: 'Filter for aquarium water' },
  { title: 'Coffee Maker Water Filter', description: 'Filter for coffee makers' },
  { title: 'Refrigerator Water Filter', description: 'Filter for refrigerator water dispensers' },
  { title: 'Under Sink Water Filter', description: 'Under sink filter for clean drinking water' },
  { title: 'Shower Filter', description: 'Filter for removing impurities from shower water' },
  { title: 'Whole House Water Filter', description: 'Filter system for treating water for the entire house' },
  { title: 'Drinking Water Filter', description: 'Filter designed specifically for drinking water' },
  { title: 'Ice Maker Water Filter', description: 'Filter for ice maker water' },
  { title: 'Whole House Carbon Filter', description: 'Carbon filter for whole house water filtration' },
  { title: 'Whole House Sediment Filter', description: 'Sediment filter for whole house water filtration' },
  { title: 'Whole House UV Filter', description: 'UV filter for whole house water treatment' },
  { title: 'Inline Carbon Filter', description: 'Inline carbon filter for water treatment' },
  { title: 'Inline Sediment Filter', description: 'Inline sediment filter for water treatment' },
  { title: 'Inline HEPA Filter', description: 'Inline HEPA filter for air purification' },
  { title: 'Air Purifier Carbon Filter', description: 'Carbon filter for air purifiers' },
  { title: 'Central Air Filter', description: 'Filter for central air systems' },
  { title: 'Washable Air Filter', description: 'Reusable and washable air filter' },
  { title: 'Disposable Air Filter', description: 'Disposable filter for air purification' },
  { title: 'HEPA Air Filter', description: 'HEPA filter for air purification' },
  { title: 'Room Air Filter', description: 'Filter designed for room air purifiers' },
  { title: 'Whole House Air Filter', description: 'Air filter system for the entire house' },
  { title: 'Air Purifier HEPA Filter Replacement', description: 'Replacement HEPA filter for air purifiers' },
  { title: 'Air Purifier Carbon Filter Replacement', description: 'Replacement carbon filter for air purifiers' },
  { title: 'Air Purifier Pre-Filter', description: 'Pre-filter for air purifiers' },
  { title: 'Ozone Filter', description: 'Filter for removing ozone from air' },
  { title: 'Electrostatic Filter', description: 'Electrostatic filter for air purification' },
  { title: 'High Efficiency Air Filter', description: 'High-efficiency air filter for HVAC systems' },
  { title: 'Anti-Allergen Filter', description: 'Filter designed to reduce allergens in the air' },
  { title: 'Anti-Microbial Filter', description: 'Filter with anti-microbial properties for air purification' },
  { title: 'Dehumidifier Filter', description: 'Filter for dehumidifiers' },
  { title: 'Ventilation Filter', description: 'Filter for ventilation systems' },
  { title: 'Car Air Filter', description: 'Air filter for vehicles' },
  { title: 'Cabin Air Filter', description: 'Filter for the cabin air of vehicles' },
  { title: 'Automotive HEPA Filter', description: 'HEPA filter for vehicles' },
  { title: 'Automotive Carbon Filter', description: 'Carbon filter for vehicles' },
  { title: 'Automotive Cabin Filter', description: 'Cabin filter for automotive air purification' },
  { title: 'Engine Air Filter', description: 'Air filter for engines' },
  { title: 'Fuel Filter', description: 'Filter for removing impurities from fuel' },
  { title: 'Transmission Filter', description: 'Filter for transmission fluid' },
  { title: 'Oil Filter', description: 'Filter for engine oil' },
  { title: 'Automatic Transmission Filter', description: 'Filter for automatic transmission fluid' },
  { title: 'Hydraulic Filter', description: 'Filter for hydraulic systems' },
  { title: 'Industrial Air Filter', description: 'Air filter for industrial applications' },
  { title: 'Industrial Water Filter', description: 'Water filter for industrial applications' },
  { title: 'Commercial Air Filter', description: 'Air filter for commercial settings' },
  { title: 'Commercial Water Filter', description: 'Water filter for commercial settings' },
  { title: 'Large Capacity Air Filter', description: 'High-capacity air filter for large spaces' },
  { title: 'Large Capacity Water Filter', description: 'High-capacity water filter for large systems' },
  { title: 'Portable Water Filter', description: 'Portable filter for on-the-go water purification' },
  { title: 'Portable Air Filter', description: 'Portable air filter for mobile use' },
  { title: 'Desk Air Filter', description: 'Compact air filter for desk use' },
  { title: 'Air Filter Replacement', description: 'Replacement filter for air purifiers' },
  { title: 'Water Filter Cartridge', description: 'Cartridge for water filtration systems' },
  { title: 'Coffee Maker Water Filter Cartridge', description: 'Replacement cartridge for coffee maker water filters' },
  { title: 'Refrigerator Water Filter Cartridge', description: 'Cartridge for refrigerator water filters' },
  { title: 'Under Sink Filter Cartridge', description: 'Cartridge for under sink water filters' },
  { title: 'Shower Filter Cartridge', description: 'Cartridge for shower water filters' },
  { title: 'Whole House Filter Cartridge', description: 'Cartridge for whole house water filters' },
  { title: 'Pool Filter Cartridge', description: 'Cartridge for swimming pool filters' },
  { title: 'Aquarium Filter Cartridge', description: 'Cartridge for aquarium filters' },
  { title: 'Industrial Water Filter Cartridge', description: 'Cartridge for industrial water filters' },
  { title: 'Commercial Water Filter Cartridge', description: 'Cartridge for commercial water filters' },
  { title: 'Sediment Filter Cartridge', description: 'Cartridge for sediment filters' },
  { title: 'Carbon Block Filter', description: 'Carbon block filter for water purification' },
  { title: 'Activated Carbon Filter', description: 'Activated carbon filter for water and air' },
  { title: 'Ceramic Water Filter', description: 'Ceramic filter for water purification' },
  { title: 'Titanium Water Filter', description: 'Titanium filter for advanced water filtration' },
  { title: 'Stainless Steel Filter', description: 'Stainless steel filter for various applications' },
  { title: 'Stainless Steel Water Filter', description: 'Stainless steel filter for water purification' },
  { title: 'Sediment Removal Filter', description: 'Filter for removing sediment from water' },
  { title: 'Pre-Carbon Filter', description: 'Pre-filter with carbon for water filtration' },
  { title: 'Bio Filter', description: 'Bio filter for biological water treatment' },
  { title: 'Iron Removal Filter', description: 'Filter for removing iron from water' },
  { title: 'Manganese Removal Filter', description: 'Filter for removing manganese from water' },
  { title: 'Copper Removal Filter', description: 'Filter for removing copper from water' },
  { title: 'Nitrate Removal Filter', description: 'Filter for removing nitrates from water' },
  { title: 'Lead Removal Filter', description: 'Filter for removing lead from water' },
  { title: 'PFAS Removal Filter', description: 'Filter for removing PFAS from water' },
  { title: 'Arsenic Removal Filter', description: 'Filter for removing arsenic from water' },
  { title: 'Radon Removal Filter', description: 'Filter for removing radon from water' },
  { title: 'Fluoride Removal Filter', description: 'Filter for removing fluoride from water' },
  { title: 'Heavy Metal Removal Filter', description: 'Filter for removing heavy metals from water' },
  { title: 'Tannin Removal Filter', description: 'Filter for removing tannins from water' },
  { title: 'VOC Removal Filter', description: 'Filter for removing volatile organic compounds from water' },
  { title: 'Sulfur Removal Filter', description: 'Filter for removing sulfur from water' },
  { title: 'Water Descaler Filter', description: 'Filter for water descaling' },
  { title: 'Limescale Removal Filter', description: 'Filter for removing limescale from water' },
  { title: 'Magnesium Removal Filter', description: 'Filter for removing magnesium from water' },
  { title: 'Calcium Removal Filter', description: 'Filter for removing calcium from water' },
  { title: 'Potassium Removal Filter', description: 'Filter for removing potassium from water' },
  { title: 'Aluminum Removal Filter', description: 'Filter for removing aluminum from water' },
  { title: 'Uranium Removal Filter', description: 'Filter for removing uranium from water' },
  { title: 'Chloramine Removal Filter', description: 'Filter for removing chloramine from water' },
  { title: 'Zinc Removal Filter', description: 'Filter for removing zinc from water' },
  { title: 'Chromium Removal Filter', description: 'Filter for removing chromium from water' },
  { title: 'Mercury Removal Filter', description: 'Filter for removing mercury from water' },
  { title: 'Cadmium Removal Filter', description: 'Filter for removing cadmium from water' },
  { title: 'Nickel Removal Filter', description: 'Filter for removing nickel from water' },
  { title: 'Silver Removal Filter', description: 'Filter for removing silver from water' },
  { title: 'Gold Removal Filter', description: 'Filter for removing gold from water' },
  { title: 'Boron Removal Filter', description: 'Filter for removing boron from water' },
  { title: 'Cyanide Removal Filter', description: 'Filter for removing cyanide from water' },
  { title: 'PCB Removal Filter', description: 'Filter for removing PCBs from water' },
  { title: 'Pesticide Removal Filter', description: 'Filter for removing pesticides from water' },
  { title: 'Herbicide Removal Filter', description: 'Filter for removing herbicides from water' },
  { title: 'Pharmaceutical Removal Filter', description: 'Filter for removing pharmaceuticals from water' },
  { title: 'Hormone Removal Filter', description: 'Filter for removing hormones from water' },
  { title: 'Virus Removal Filter', description: 'Filter for removing viruses from water' },
  { title: 'Pathogen Removal Filter', description: 'Filter for removing pathogens from water' },
  { title: 'Protozoa Removal Filter', description: 'Filter for removing protozoa from water' },
  { title: 'Cyst Removal Filter', description: 'Filter for removing cysts from water' },
  { title: 'Giardia Removal Filter', description: 'Filter for removing Giardia from water' },
  { title: 'Cryptosporidium Removal Filter', description: 'Filter for removing Cryptosporidium from water' },
  { title: 'Algae Removal Filter', description: 'Filter for removing algae from water' },
  { title: 'Biofilm Removal Filter', description: 'Filter for removing biofilm from water' },
  { title: 'Slime Removal Filter', description: 'Filter for removing slime from water' },
  { title: 'Microbial Removal Filter', description: 'Filter for removing microbes from water' },
  { title: 'Bacterial Removal Filter', description: 'Filter for removing bacteria from water' },
  { title: 'Viral Removal Filter', description: 'Filter for removing viruses from water' },
  { title: 'Pathogen Removal Filter', description: 'Filter for removing pathogens from water' },
  { title: 'Radiological Removal Filter', description: 'Filter for removing radiological contaminants from water' },
  { title: 'Organic Removal Filter', description: 'Filter for removing organic contaminants from water' },
  { title: 'Inorganic Removal Filter', description: 'Filter for removing inorganic contaminants from water' },
  { title: 'Particle Removal Filter', description: 'Filter for removing particles from water' },
  { title: 'Dirt Removal Filter', description: 'Filter for removing dirt from water' },
  { title: 'Sand Removal Filter', description: 'Filter for removing sand from water' },
  { title: 'Silt Removal Filter', description: 'Filter for removing silt from water' },
  { title: 'Mud Removal Filter', description: 'Filter for removing mud from water' },
  { title: 'Dust Removal Filter', description: 'Filter for removing dust from water' },
  { title: 'Ash Removal Filter', description: 'Filter for removing ash from water' },
  { title: 'Rubble Removal Filter', description: 'Filter for removing rubble from water' },
  { title: 'Debris Removal Filter', description: 'Filter for removing debris from water' },
  { title: 'Filtration Solution System', description: 'Comprehensive filtration system for water and air' },
  { title: 'Filtration Unit', description: 'Standalone filtration unit for water and air' },
  { title: 'Filtration Device', description: 'Device for filtering water and air' },
  { title: 'Filtration Kit', description: 'Complete filtration kit for various applications' },
  { title: 'Portable Filtration System', description: 'Portable system for filtering water and air' },
  { title: 'Modular Filtration System', description: 'Modular system for customizable filtration' },
  { title: 'Smart Filtration System', description: 'Advanced filtration system with smart features' },
  { title: 'Eco-Friendly Filtration System', description: 'Environmentally friendly filtration system' },
  { title: 'Energy-Efficient Filtration System', description: 'Energy-efficient filtration system for sustainable use' },
  { title: 'Silent Filtration System', description: 'Noise-free filtration system for quiet operation' },
  { title: 'High-Capacity Filtration System', description: 'High-capacity system for large volume filtration' },
  { title: 'Compact Filtration System', description: 'Compact system for space-saving filtration' },
  { title: 'Heavy-Duty Filtration System', description: 'Heavy-duty system for industrial filtration' },
  { title: 'Customizable Filtration System', description: 'Customizable system for specific filtration needs' },
  { title: 'Whole House Filtration System', description: 'Filtration system for the entire house' },
  { title: 'Point-of-Use Filtration System', description: 'Filtration system for point-of-use applications' },
  { title: 'Countertop Filtration System', description: 'Countertop system for easy access to filtered water' },
  { title: 'Undercounter Filtration System', description: 'Undercounter system for discreet filtration' },
  { title: 'Wall-Mounted Filtration System', description: 'Wall-mounted system for space-saving filtration' },
  { title: 'Cartridge Filtration System', description: 'Cartridge-based filtration system for easy maintenance' },
  { title: 'Tankless Filtration System', description: 'Tankless system for continuous filtration' },
  { title: 'Gravity Filtration System', description: 'Gravity-based system for passive filtration' },
  { title: 'Pressure Filtration System', description: 'Pressure-driven system for high-efficiency filtration' },
  { title: 'Vacuum Filtration System', description: 'Vacuum-driven system for advanced filtration' },
  { title: 'High-Flow Filtration System', description: 'High-flow system for rapid filtration' },
  { title: 'Low-Flow Filtration System', description: 'Low-flow system for precise filtration' },
  { title: 'Ion Exchange Filtration System', description: 'Ion exchange system for advanced water treatment' },
  { title: 'Nano Filtration System', description: 'Nanofiltration system for ultra-fine filtration' },
  { title: 'Micro Filtration System', description: 'Microfiltration system for fine particle removal' },
  { title: 'Ultra Filtration System', description: 'Ultrafiltration system for sub-micron filtration' },
  { title: 'Nano Fiber Filter', description: 'Nano fiber filter for high-tech filtration' },
  { title: 'Ultra Fiber Filter', description: 'Ultra fiber filter for advanced filtration' },
  { title: 'Electrostatic Air Filtration System', description: 'Electrostatic system for efficient air filtration' },
  { title: 'Biological Filtration System', description: 'Biological system for natural water treatment' },
  { title: 'Chemical Filtration System', description: 'Chemical-based system for targeted filtration' },
  { title: 'Mechanical Filtration System', description: 'Mechanical system for physical filtration' },
  { title: 'Ceramic Filtration System', description: 'Ceramic-based system for durable filtration' },
  { title: 'Metal Filtration System', description: 'Metal-based system for robust filtration' },
  { title: 'Plastic Filtration System', description: 'Plastic-based system for lightweight filtration' },
  { title: 'Glass Filtration System', description: 'Glass-based system for high-purity filtration' },
  { title: 'Stainless Steel Filtration System', description: 'Stainless steel system for corrosion-resistant filtration' },
  { title: 'Titanium Filtration System', description: 'Titanium system for ultra-durable filtration' },
  { title: 'Aluminum Filtration System', description: 'Aluminum system for lightweight filtration' },
  { title: 'Copper Filtration System', description: 'Copper system for antimicrobial filtration' },
  { title: 'Brass Filtration System', description: 'Brass system for durable filtration' },
  { title: 'PVC Filtration System', description: 'PVC-based system for cost-effective filtration' },
  { title: 'Carbon Fiber Filtration System', description: 'Carbon fiber system for high-strength filtration' },
  { title: 'Graphene Filtration System', description: 'Graphene-based system for cutting-edge filtration' },
  { title: '3D Printed Filtration System', description: '3D printed system for customized filtration' },
  { title: 'Smart Home Filtration System', description: 'Smart home compatible filtration system' },
  { title: 'Wi-Fi Enabled Filtration System', description: 'Wi-Fi enabled system for remote monitoring and control' },
  { title: 'Bluetooth Enabled Filtration System', description: 'Bluetooth enabled system for easy connectivity' },
  { title: 'Voice-Controlled Filtration System', description: 'Voice-controlled system for hands-free operation' },
  { title: 'App-Controlled Filtration System', description: 'App-controlled system for convenient operation' },
  { title: 'AI-Powered Filtration System', description: 'AI-powered system for intelligent filtration' },
  { title: 'Solar-Powered Filtration System', description: 'Solar-powered system for eco-friendly filtration' },
  { title: 'Wind-Powered Filtration System', description: 'Wind-powered system for renewable energy filtration' },
  { title: 'Water-Powered Filtration System', description: 'Water-powered system for sustainable filtration' },
  { title: 'Battery-Powered Filtration System', description: 'Battery-powered system for portable filtration' },
  { title: 'Rechargeable Filtration System', description: 'Rechargeable system for continuous filtration' },
  { title: 'Hybrid Filtration System', description: 'Hybrid system combining multiple filtration technologies' },
  { title: 'Portable Solar Filtration System', description: 'Portable solar-powered system for off-grid filtration' },
  { title: 'Portable Battery Filtration System', description: 'Portable battery-powered system for mobile filtration' },
  { title: 'Portable Hybrid Filtration System', description: 'Portable hybrid system for versatile filtration' },
  { title: 'Mini Filtration System', description: 'Compact mini system for personal filtration' },
  { title: 'Micro Filtration System', description: 'Micro-sized system for precise filtration' },
  { title: 'Nano Filtration System', description: 'Nano-sized system for ultra-precise filtration' },
  { title: 'Large Scale Filtration System', description: 'Large scale system for industrial filtration' },
  { title: 'Small Scale Filtration System', description: 'Small scale system for targeted filtration' },
  { title: 'Bench-Scale Filtration System', description: 'Bench-scale system for laboratory use' },
  { title: 'Pilot-Scale Filtration System', description: 'Pilot-scale system for experimental filtration' },
  { title: 'Full-Scale Filtration System', description: 'Full-scale system for complete filtration' },
  { title: 'OEM Filtration System', description: 'OEM system for original equipment manufacturers' },
  { title: 'Aftermarket Filtration System', description: 'Aftermarket system for customized filtration' },
  { title: 'Retrofit Filtration System', description: 'Retrofit system for upgrading existing filtration systems' },
  { title: 'Replacement Filtration System', description: 'Replacement system for existing filtration setups' },
  { title: 'Custom Filtration System', description: 'Custom-built system for specific filtration needs' },
  { title: 'Turnkey Filtration System', description: 'Turnkey system for ready-to-use filtration' },
  { title: 'Plug-and-Play Filtration System', description: 'Plug-and-play system for easy installation' },
  { title: 'On-Demand Filtration System', description: 'On-demand system for instant filtration' },
  { title: 'Continuous Filtration System', description: 'Continuous system for uninterrupted filtration' },
  { title: 'Batch Filtration System', description: 'Batch system for segmented filtration processes' },
  { title: 'Cyclic Filtration System', description: 'Cyclic system for periodic filtration' },
  { title: 'Dual-Stage Filtration System', description: 'Dual-stage system for enhanced filtration' },
  { title: 'Triple-Stage Filtration System', description: 'Triple-stage system for comprehensive filtration' },
  { title: 'Quad-Stage Filtration System', description: 'Quad-stage system for ultra-comprehensive filtration' },
  { title: 'Multi-Stage Filtration System', description: 'Multi-stage system for complex filtration needs' },
  { title: 'Modular Filtration System', description: 'Modular system for expandable filtration' },
  { title: 'Single-Stage Filtration System', description: 'Single-stage system for simple filtration' },
  { title: 'Inline Filtration System', description: 'Inline system for direct filtration' },
  { title: 'Offline Filtration System', description: 'Offline system for periodic filtration' },
  { title: 'Parallel Filtration System', description: 'Parallel system for simultaneous filtration' },
  { title: 'Series Filtration System', description: 'Series system for sequential filtration' },
  { title: 'Independent Filtration System', description: 'Independent system for stand-alone filtration' },
  { title: 'Dependent Filtration System', description: 'Dependent system for integrated filtration' },
  { title: 'Fixed Filtration System', description: 'Fixed system for permanent filtration setups' },
  { title: 'Mobile Filtration System', description: 'Mobile system for portable filtration' },
  { title: 'Stationary Filtration System', description: 'Stationary system for fixed filtration setups' },
  { title: 'Mobile Cart Filtration System', description: 'Mobile cart system for easy transport of filtration equipment' },
  { title: 'Filtration Solution', description: 'Comprehensive filtration solution for various applications' },
  { title: 'Industrial Filtration System', description: 'Heavy-duty filtration system for industrial use' },
  { title: 'Commercial Filtration System', description: 'Robust filtration system for commercial applications' },
  { title: 'Residential Filtration System', description: 'Filtration system designed for residential use' },
  { title: 'Portable Filtration System', description: 'Compact and portable system for filtration on the go' },
  { title: 'Compact Filtration Unit', description: 'Space-saving filtration unit for smaller spaces' },
  { title: 'Wall-Mounted Filtration Unit', description: 'Wall-mounted unit for easy installation and access' },
  { title: 'High-Efficiency Filtration System', description: 'High-efficiency system for optimal filtration performance' },
  { title: 'Water Filtration System', description: 'Comprehensive water filtration system for clean and safe water' },
  { title: 'Air Filtration System', description: 'Complete air filtration system for healthy indoor air quality' },
  { title: 'Combination Filtration System', description: 'Dual-purpose system for both air and water filtration' },
  { title: 'Custom Filtration Solution', description: 'Tailored filtration solution to meet specific needs' }
],

'Hardware Tools & Equipment' => [
  { title: 'Hammer', description: 'Durable hammer for various tasks' },
  { title: 'Screwdriver Set', description: 'Set of screwdrivers with various heads' },
  { title: 'Adjustable Wrench', description: 'Versatile wrench for multiple applications' },
  { title: 'Cordless Drill', description: 'High-performance cordless drill with battery' },
  { title: 'Tape Measure', description: 'Reliable tape measure for accurate measurements' },
  { title: 'Utility Knife', description: 'Sharp utility knife for cutting tasks' },
  { title: 'Pliers Set', description: 'Set of pliers for gripping and cutting' },
  { title: 'Level', description: 'Precision level for ensuring accurate alignment' },
  { title: 'Circular Saw', description: 'Powerful circular saw for cutting wood and other materials' },
  { title: 'Chisel Set', description: 'Set of chisels for woodworking and carving' },
  { title: 'Socket Wrench Set', description: 'Comprehensive socket wrench set for automotive work' },
  { title: 'Allen Wrench Set', description: 'Hex key set for assembling furniture and equipment' },
  { title: 'Claw Hammer', description: 'Heavy-duty claw hammer for construction tasks' },
  { title: 'Rubber Mallet', description: 'Soft rubber mallet for gentle striking' },
  { title: 'Hacksaw', description: 'Adjustable hacksaw for cutting metal and plastic' },
  { title: 'Handsaw', description: 'Sharp handsaw for precise cutting of wood' },
  { title: 'Jigsaw', description: 'Electric jigsaw for curved and intricate cuts' },
  { title: 'Sledgehammer', description: 'Heavy sledgehammer for demolition work' },
  { title: 'Pipe Wrench', description: 'Adjustable pipe wrench for plumbing tasks' },
  { title: 'Needle-Nose Pliers', description: 'Long-nose pliers for reaching tight spaces' },
  { title: 'Vise Grip Pliers', description: 'Locking pliers with adjustable grip' },
  { title: 'Crescent Wrench', description: 'Adjustable crescent wrench for various nuts and bolts' },
  { title: 'Tin Snips', description: 'Sharp tin snips for cutting sheet metal' },
  { title: 'Wire Strippers', description: 'Precision wire strippers for electrical work' },
  { title: 'Bolt Cutters', description: 'Heavy-duty bolt cutters for cutting metal rods and chains' },
  { title: 'Staple Gun', description: 'Manual staple gun for fastening materials' },
  { title: 'Impact Driver', description: 'High-torque impact driver for driving screws and bolts' },
  { title: 'Angle Grinder', description: 'Powerful angle grinder for grinding and cutting' },
  { title: 'Table Saw', description: 'Large table saw for woodworking projects' },
  { title: 'Miter Saw', description: 'Precision miter saw for angled cuts' },
  { title: 'Rotary Tool', description: 'Versatile rotary tool for sanding, cutting, and engraving' },
  { title: 'Heat Gun', description: 'Adjustable heat gun for stripping paint and other tasks' },
  { title: 'Soldering Iron', description: 'Electric soldering iron for electronic repairs' },
  { title: 'Combination Square', description: 'Multi-purpose combination square for measuring and marking' },
  { title: 'Carpenters Pencil', description: 'Durable pencil for marking wood and other materials' },
  { title: 'C-Clamps', description: 'Strong C-clamps for holding materials in place' },
  { title: 'Bar Clamps', description: 'Adjustable bar clamps for woodworking and assembly' },
  { title: 'G-Clamps', description: 'Heavy-duty G-clamps for securing workpieces' },
  { title: 'Wood Rasp', description: 'Coarse wood rasp for shaping and smoothing wood' },
  { title: 'Flat File', description: 'Flat file for smoothing metal and other materials' },
  { title: 'Round File', description: 'Round file for enlarging holes and shaping curves' },
  { title: 'Sandpaper Assortment', description: 'Variety pack of sandpaper for different grits' },
  { title: 'Workbench', description: 'Sturdy workbench for all your projects' },
  { title: 'Toolbox', description: 'Portable toolbox for organizing tools' },
  { title: 'Tool Belt', description: 'Convenient tool belt for carrying essentials' },
  { title: 'Safety Goggles', description: 'Protective safety goggles for eye protection' },
  { title: 'Ear Protection', description: 'Noise-cancelling ear protection for loud environments' },
  { title: 'Work Gloves', description: 'Durable work gloves for hand protection' },
  { title: 'Knee Pads', description: 'Comfortable knee pads for extended work' },
  { title: 'Dust Mask', description: 'Breathable dust mask for protection from particles' },
  { title: 'Hard Hat', description: 'Impact-resistant hard hat for head protection' },
  { title: 'Respirator', description: 'Advanced respirator for protection from fumes and dust' },
  { title: 'Utility Apron', description: 'Heavy-duty utility apron with multiple pockets' },
  { title: 'Extension Cord', description: 'Long extension cord for powering tools at a distance' },
  { title: 'Work Light', description: 'Bright work light for illuminating your workspace' },
  { title: 'Ladder', description: 'Sturdy ladder for reaching high places' },
  { title: 'Step Stool', description: 'Compact step stool for easy access to elevated areas' },
  { title: 'Extension Ladder', description: 'Adjustable extension ladder for extended reach' },
  { title: 'Sawhorse', description: 'Durable sawhorse for supporting workpieces' },
  { title: 'Folding Workbench', description: 'Portable folding workbench for on-the-go projects' },
  { title: 'Tool Organizer', description: 'Wall-mounted tool organizer for easy access' },
  { title: 'Magnetic Tool Holder', description: 'Magnetic tool holder for quick storage' },
  { title: 'Tool Chest', description: 'Large tool chest for comprehensive tool storage' },
  { title: 'Drill Bit Set', description: 'Assorted drill bit set for various materials' },
  { title: 'Hole Saw Kit', description: 'Complete hole saw kit for cutting large holes' },
  { title: 'Wood Router', description: 'Powerful wood router for shaping and trimming' },
  { title: 'Belt Sander', description: 'Electric belt sander for smoothing surfaces' },
  { title: 'Orbital Sander', description: 'Random orbital sander for a smooth finish' },
  { title: 'Palm Sander', description: 'Compact palm sander for detailed work' },
  { title: 'Bench Grinder', description: 'Sturdy bench grinder for sharpening tools' },
  { title: 'Chop Saw', description: 'Heavy-duty chop saw for cutting metal and wood' },
  { title: 'Reciprocating Saw', description: 'Versatile reciprocating saw for demolition work' },
  { title: 'Planer', description: 'Electric planer for smoothing and leveling wood' },
  { title: 'Nail Gun', description: 'Pneumatic nail gun for fast and efficient nailing' },
  { title: 'Staple Gun', description: 'Electric staple gun for upholstery and crafts' },
  { title: 'Brad Nailer', description: 'Precision brad nailer for trim work' },
  { title: 'Finish Nailer', description: 'Finish nailer for carpentry and finishing tasks' },
  { title: 'Palm Nailer', description: 'Compact palm nailer for tight spaces' },
  { title: 'Air Compressor', description: 'Portable air compressor for powering pneumatic tools' },
  { title: 'Air Hose', description: 'Flexible air hose for connecting pneumatic tools' },
  { title: 'Air Tool Kit', description: 'Complete air tool kit for various applications' },
  { title: 'Shop Vacuum', description: 'Powerful shop vacuum for cleaning up debris' },
  { title: 'Dust Collector', description: 'Efficient dust collector for woodworking shops' },
  { title: 'Blower', description: 'Electric blower for clearing leaves and debris' },
  { title: 'Pressure Washer', description: 'High-pressure washer for cleaning surfaces' },
  { title: 'Power Washer', description: 'Gas-powered washer for heavy-duty cleaning' },
  { title: 'Paint Sprayer', description: 'Electric paint sprayer for smooth and even coverage' },
  { title: 'Caulking Gun', description: 'Manual caulking gun for sealing joints' },
  { title: 'Putty Knife', description: 'Flexible putty knife for spreading and scraping' },
  { title: 'Painters Tape', description: 'High-quality painters tape for clean lines' },
  { title: 'Paint Roller', description: 'Durable paint roller for even application' },
  { title: 'Paint Tray', description: 'Sturdy paint tray for holding paint and rollers' },
  { title: 'Paintbrush Set', description: 'Set of paintbrushes for detailed painting' },
  { title: 'Drop Cloth', description: 'Protective drop cloth for covering surfaces' },
  { title: 'Lawn Mower', description: 'Gas-powered lawn mower for cutting grass' },
  { title: 'Electric Lawn Mower', description: 'Eco-friendly electric lawn mower' },
  { title: 'String Trimmer', description: 'Cordless string trimmer for edging and trimming' },
  { title: 'Hedge Trimmer', description: 'Electric hedge trimmer for shaping bushes' },
  { title: 'Leaf Blower', description: 'High-speed leaf blower for clearing debris' },
  { title: 'Chainsaw', description: 'Powerful chainsaw for cutting trees and branches' },
  { title: 'Garden Shovel', description: 'Heavy-duty garden shovel for digging' },
  { title: 'Garden Hoe', description: 'Durable garden hoe for tilling soil' },
  { title: 'Garden Rake', description: 'Sturdy garden rake for clearing leaves' },
  { title: 'Pruning Shears', description: 'Sharp pruning shears for trimming plants' },
  { title: 'Loppers', description: 'Heavy-duty loppers for cutting thick branches' },
  { title: 'Wheelbarrow', description: 'Robust wheelbarrow for transporting materials' },
  { title: 'Garden Hose', description: 'Flexible garden hose for watering plants' },
  { title: 'Hose Reel', description: 'Convenient hose reel for easy storage' },
  { title: 'Watering Can', description: 'Classic watering can for precise watering' },
  { title: 'Sprinkler', description: 'Automatic sprinkler for lawn irrigation' },
  { title: 'Garden Trowel', description: 'Handy garden trowel for planting and digging' },
  { title: 'Weed Puller', description: 'Ergonomic weed puller for removing weeds' },
  { title: 'Garden Fork', description: 'Durable garden fork for turning soil' },
  { title: 'Post Hole Digger', description: 'Manual post hole digger for fence installation' },
  { title: 'Garden Cart', description: 'Heavy-duty garden cart for transporting tools' },
  { title: 'Cultivator', description: 'Hand cultivator for aerating soil' },
  { title: 'Garden Kneeler', description: 'Padded garden kneeler for comfortable gardening' },
  { title: 'Compost Bin', description: 'Large compost bin for organic waste' },
  { title: 'Soil Tester', description: 'Soil tester for measuring pH and nutrient levels' },
  { title: 'Pruning Saw', description: 'Compact pruning saw for cutting branches' },
  { title: 'Garden Sprayer', description: 'Pressure garden sprayer for applying treatments' },
  { title: 'Water Timer', description: 'Automatic water timer for irrigation control' },
  { title: 'Mulch', description: 'High-quality mulch for garden beds' },
  { title: 'Garden Edging', description: 'Decorative garden edging for borders' },
  { title: 'Fence Pliers', description: 'Multi-purpose fence pliers for installation and repair' },
  { title: 'Wire Cutters', description: 'Heavy-duty wire cutters for cutting fencing' },
  { title: 'Bolt Fasteners', description: 'Assorted bolt fasteners for various applications' },
  { title: 'Nails Assortment', description: 'Variety pack of nails for different projects' },
  { title: 'Screws Assortment', description: 'Assorted screws for wood, metal, and drywall' },
  { title: 'Anchors Assortment', description: 'Complete anchor set for securing to walls' },
  { title: 'Hooks Assortment', description: 'Variety pack of hooks for hanging items' },
  { title: 'Magnets', description: 'Strong magnets for holding and organizing tools' },
  { title: 'O-Ring Assortment', description: 'Assorted O-rings for plumbing and sealing' },
  { title: 'Spring Assortment', description: 'Variety pack of springs for various applications' },
  { title: 'Grommet Kit', description: 'Complete grommet kit for fabric and tarps' },
  { title: 'Hinge Set', description: 'Set of hinges for doors and cabinets' },
  { title: 'Latch Set', description: 'Complete latch set for securing gates and doors' },
  { title: 'Padlock Set', description: 'High-security padlock set for locking tools and equipment' },
  { title: 'Chains', description: 'Heavy-duty chains for securing loads' },
  { title: 'Cable Ties', description: 'Assorted cable ties for organizing wires' },
  { title: 'Bungee Cords', description: 'Elastic bungee cords for securing loads' },
  { title: 'Tarps', description: 'Heavy-duty tarps for covering and protecting' },
  { title: 'Rope Assortment', description: 'Variety pack of ropes for various uses' },
  { title: 'Ratchet Straps', description: 'Strong ratchet straps for securing loads' },
  { title: 'Wire Brushes', description: 'Set of wire brushes for cleaning and polishing' },
  { title: 'Bench Vise', description: 'Sturdy bench vise for holding workpieces' },
  { title: 'Anvil', description: 'Heavy-duty anvil for blacksmithing and metalworking' },
  { title: 'Forge', description: 'High-temperature forge for metalworking' },
  { title: 'Chisel Set', description: 'Durable chisel set for metalworking' },
  { title: 'Machinist Hammer', description: 'Precision hammer for metalworking' },
  { title: 'Pry Bar', description: 'Strong pry bar for demolition and construction' },
  { title: 'Wrecking Bar', description: 'Heavy-duty wrecking bar for tearing down structures' },
  { title: 'Crowbar', description: 'Versatile crowbar for prying and lifting' },
  { title: 'Roofing Hammer', description: 'Specialized hammer for roofing tasks' },
  { title: 'Masonry Hammer', description: 'Heavy-duty hammer for masonry work' },
  { title: 'Trowel', description: 'Durable trowel for bricklaying and plastering' },
  { title: 'Masons Line', description: 'Strong masons line for marking straight lines' },
  { title: 'Masons Level', description: 'Precision level for masonry work' },
  { title: 'Concrete Float', description: 'Smooth concrete float for finishing surfaces' },
  { title: 'Concrete Trowel', description: 'Large concrete trowel for smoothing surfaces' },
  { title: 'Tile Cutter', description: 'Manual tile cutter for ceramic and porcelain tiles' },
  { title: 'Tile Saw', description: 'Electric tile saw for cutting tiles with precision' },
  { title: 'Tile Nippers', description: 'Tile nippers for shaping and cutting tiles' },
  { title: 'Grout Float', description: 'Soft grout float for applying grout' },
  { title: 'Grout Sponge', description: 'Absorbent grout sponge for cleaning tiles' },
  { title: 'Caulk Remover', description: 'Handy caulk remover for removing old caulk' },
  { title: 'Sealant Gun', description: 'Professional sealant gun for applying sealant' },
  { title: 'Adhesive Trowel', description: 'Notched adhesive trowel for spreading tile adhesive' },
  { title: 'Plastering Trowel', description: 'Smooth plastering trowel for applying plaster' },
  { title: 'Plastering Hawk', description: 'Lightweight plastering hawk for holding plaster' },
  { title: 'Drywall Saw', description: 'Jab saw for cutting drywall' },
  { title: 'Drywall T-Square', description: 'Large T-square for cutting drywall' },
  { title: 'Drywall Rasp', description: 'Coarse rasp for smoothing drywall edges' },
  { title: 'Drywall Lifter', description: 'Handy drywall lifter for positioning sheets' },
  { title: 'Taping Knife', description: 'Flexible taping knife for applying joint compound' },
  { title: 'Joint Knife', description: 'Sturdy joint knife for finishing drywall joints' },
  { title: 'Corner Trowel', description: 'Corner trowel for smoothing inside corners' },
  { title: 'Drywall Sanding Block', description: 'Durable sanding block for smoothing drywall' },
  { title: 'Drywall Pole Sander', description: 'Pole sander for reaching high areas on drywall' },
  { title: 'Drywall Lift', description: 'Heavy-duty drywall lift for installing ceiling sheets' },
  { title: 'Drywall Screw Gun', description: 'Specialized screw gun for installing drywall' },
  { title: 'Stud Finder', description: 'Electronic stud finder for locating wall studs' },
  { title: 'Electric Stapler', description: 'Powerful electric stapler for upholstery and crafts' },
  { title: 'Manual Stapler', description: 'Versatile manual stapler for everyday use' },
  { title: 'Staple Remover', description: 'Handy staple remover for pulling out staples' },
  { title: 'Nail Puller', description: 'Effective nail puller for removing nails' },
  { title: 'Rivet Gun', description: 'Pneumatic rivet gun for installing rivets' },
  { title: 'Hand Riveter', description: 'Manual hand riveter for small projects' },
  { title: 'Pop Rivets', description: 'Assorted pop rivets for various applications' },
  { title: 'Rivet Set', description: 'Complete rivet set for metalworking' },
  { title: 'Rivet Anvil', description: 'Sturdy rivet anvil for setting rivets' },
  { title: 'Rivet Dies', description: 'Precision rivet dies for forming rivets' },
  { title: 'Pneumatic Hammer', description: 'Air-powered pneumatic hammer for heavy-duty tasks' },
  { title: 'Air Drill', description: 'High-speed air drill for automotive work' },
  { title: 'Air Ratchet', description: 'Compact air ratchet for tightening bolts' },
  { title: 'Air Impact Wrench', description: 'Powerful air impact wrench for automotive repairs' },
  { title: 'Air Hammer', description: 'Air hammer for chiseling and breaking' },
  { title: 'Air Grinder', description: 'High-speed air grinder for polishing and grinding' },
  { title: 'Air Sanders', description: 'Pneumatic air sanders for finishing work' },
  { title: 'Air Saw', description: 'Pneumatic air saw for cutting metal and plastic' },
  { title: 'Air Chisel Set', description: 'Complete air chisel set for demolition' },
  { title: 'Air Grease Gun', description: 'Pneumatic grease gun for lubrication' },
  { title: 'Air Tire Inflator', description: 'Portable air tire inflator for automotive use' },
  { title: 'Air Blow Gun', description: 'High-pressure air blow gun for cleaning debris' },
  { title: 'Air Hose Reel', description: 'Retractable air hose reel for easy storage' },
  { title: 'Air Fittings Set', description: 'Assorted air fittings for pneumatic tools' },
  { title: 'Air Regulator', description: 'Adjustable air regulator for controlling pressure' },
  { title: 'Air Compressor Oil', description: 'High-quality air compressor oil for lubrication' },
  { title: 'Air Compressor Filter', description: 'Replacement filter for air compressors' },
  { title: 'Air Couplers', description: 'Quick-connect air couplers for pneumatic tools' },
  { title: 'Air Hose Connectors', description: 'Assorted air hose connectors for various tools' },
  { title: 'Air Muffler', description: 'Noise-reducing air muffler for pneumatic tools' },
  { title: 'Hand Truck', description: 'Steady hand truck for moving heavy items' },
  { title: 'Platform Truck', description: 'Large platform truck for transporting goods' },
  { title: 'Pallet Jack', description: 'Heavy-duty pallet jack for lifting pallets' },
  { title: 'Hydraulic Jack', description: 'Hydraulic jack for lifting vehicles' },
  { title: 'Bottle Jack', description: 'Compact bottle jack for lifting heavy loads' },
  { title: 'Floor Jack', description: 'Low-profile floor jack for automotive work' },
  { title: 'Jack Stands', description: 'Strong jack stands for supporting lifted vehicles' },
  { title: 'Engine Hoist', description: 'Heavy-duty engine hoist for lifting engines' },
  { title: 'Engine Stand', description: 'Rotating engine stand for engine repairs' },
  { title: 'Transmission Jack', description: 'Adjustable transmission jack for vehicle repairs' },
  { title: 'Creeper', description: 'Comfortable creeper for working under vehicles' },
  { title: 'Creeper Seat', description: 'Rolling creeper seat for comfortable work' },
  { title: 'Fender Cover', description: 'Protective fender cover for automotive work' },
  { title: 'Mechanic Gloves', description: 'Durable mechanic gloves for hand protection' },
  { title: 'Mechanic Stool', description: 'Adjustable mechanic stool for garage work' },
  { title: 'Oil Drain Pan', description: 'Large oil drain pan for vehicle maintenance' },
  { title: 'Fluid Pump', description: 'Manual fluid pump for transferring liquids' },
  { title: 'Oil Filter Wrench', description: 'Adjustable oil filter wrench for easy removal' },
  { title: 'Spark Plug Socket', description: 'Specialized socket for removing spark plugs' },
  { title: 'Battery Charger', description: 'Automatic battery charger for maintaining batteries' },
  { title: 'Jumper Cables', description: 'Heavy-duty jumper cables for jump-starting vehicles' },
  { title: 'Diagnostic Tool', description: 'OBD-II diagnostic tool for checking engine codes' },
  { title: 'Torque Wrench', description: 'Precision torque wrench for tightening bolts' },
  { title: 'Breaker Bar', description: 'Long breaker bar for loosening tight bolts' },
  { title: 'Ratchet Handle', description: 'Reversible ratchet handle for socket sets' },
  { title: 'Extension Bars', description: 'Assorted extension bars for reaching tight spaces' },
  { title: 'Universal Joint', description: 'Swivel universal joint for socket sets' },
  { title: 'Torque Adapter', description: 'Electronic torque adapter for accurate measurements' },
  { title: 'Socket Extensions', description: 'Extra-long socket extensions for deep recesses' },
  { title: 'Spark Plug Gap Tool', description: 'Precision gap tool for setting spark plug gaps' },
  { title: 'Battery Terminal Cleaner', description: 'Battery terminal cleaner for removing corrosion' },
  { title: 'Battery Tester', description: 'Portable battery tester for checking charge levels' },
  { title: 'Funnel Set', description: 'Assorted funnel set for pouring fluids' },
  { title: 'Hose Clamp Pliers', description: 'Specialized pliers for removing hose clamps' },
  { title: 'Radiator Pressure Tester', description: 'Radiator pressure tester for checking leaks' },
  { title: 'Compression Tester', description: 'Compression tester for checking engine compression' },
  { title: 'Vacuum Pump', description: 'Manual vacuum pump for testing vacuum systems' },
  { title: 'Fuel Pressure Tester', description: 'Fuel pressure tester for checking fuel systems' },
  { title: 'Brake Bleeder Kit', description: 'Complete brake bleeder kit for brake maintenance' },
  { title: 'Brake Caliper Tool', description: 'Specialized tool for compressing brake calipers' },
  { title: 'Brake Spring Tool', description: 'Brake spring tool for installing and removing springs' },
  { title: 'Brake Lining Thickness Gauge', description: 'Gauge for measuring brake lining thickness' },
  { title: 'Brake Rotor Gauge', description: 'Brake rotor gauge for measuring rotor thickness' },
  { title: 'Disc Brake Pad Spreader', description: 'Tool for spreading disc brake pads' },
  { title: 'Drum Brake Gauge', description: 'Drum brake gauge for measuring drum diameter' },
  { title: 'Steering Wheel Puller', description: 'Steering wheel puller for removing steering wheels' },
  { title: 'Tie Rod End Remover', description: 'Tool for removing tie rod ends' },
  { title: 'Ball Joint Separator', description: 'Tool for separating ball joints' },
  { title: 'Pitman Arm Puller', description: 'Pitman arm puller for steering components' },
  { title: 'U-Joint Puller', description: 'Tool for removing universal joints' },
  { title: 'Bearing Puller', description: 'Bearing puller for removing bearings' },
  { title: 'Hub Puller', description: 'Hub puller for removing wheel hubs' },
  { title: 'Gear Puller', description: 'Gear puller for removing gears and pulleys' },
  { title: 'Timing Light', description: 'Timing light for setting engine timing' },
  { title: 'Engine Compression Gauge', description: 'Gauge for measuring engine compression' },
  { title: 'Engine Stand Adapter', description: 'Adapter for mounting engines on stands' },
  { title: 'Flywheel Holder', description: 'Tool for holding flywheels during maintenance' },
  { title: 'Valve Spring Compressor', description: 'Tool for compressing valve springs' },
  { title: 'Piston Ring Compressor', description: 'Tool for compressing piston rings' },
  { title: 'Ring Expander', description: 'Tool for expanding piston rings during installation' },
  { title: 'Crankshaft Pulley Tool', description: 'Tool for removing crankshaft pulleys' },
  { title: 'Camshaft Holding Tool', description: 'Tool for holding camshafts in place during timing' },
  { title: 'Timing Chain Tool', description: 'Specialized tool for timing chain installation' },
  { title: 'Engine Oil Pressure Tester', description: 'Gauge for testing engine oil pressure' },
  { title: 'Engine Block Tester', description: 'Tool for checking engine block integrity' },
  { title: 'Engine Lift Plate', description: 'Lift plate for removing engines from vehicles' },
  { title: 'Cylinder Hone', description: 'Tool for honing engine cylinders' },
  { title: 'Valve Seat Cutter', description: 'Precision valve seat cutter for engine rebuilds' },
  { title: 'Cylinder Head Stand', description: 'Stand for holding cylinder heads during maintenance' },
  { title: 'Flywheel Turner', description: 'Tool for turning flywheels during engine work' },
  { title: 'Clutch Alignment Tool', description: 'Tool for aligning clutches during installation' },
  { title: 'Transmission Alignment Tool', description: 'Tool for aligning transmissions during installation' },
  { title: 'Transmission Fluid Pump', description: 'Pump for transferring transmission fluid' },
  { title: 'Gear Oil Pump', description: 'Manual pump for transferring gear oil' },
  { title: 'Transmission Jack Adapter', description: 'Adapter for using transmission jack with different vehicles' },
  { title: 'Transfer Case Adapter', description: 'Adapter for removing transfer cases from vehicles' },
  { title: 'Differential Cover Gasket', description: 'Gasket for sealing differential covers' },
  { title: 'Pinion Yoke Tool', description: 'Tool for removing and installing pinion yokes' },
  { title: 'Bearing Race Installer', description: 'Tool for installing bearing races' },
  { title: 'Axle Nut Socket', description: 'Specialized socket for removing axle nuts' },
  { title: 'Differential Carrier Bearing Puller', description: 'Tool for removing differential carrier bearings' },
  { title: 'Differential Bearing Puller', description: 'Tool for removing differential bearings' },
  { title: 'Differential Pinion Bearing Puller', description: 'Tool for removing pinion bearings' },
  { title: 'Differential Case Spreader', description: 'Tool for spreading differential cases during maintenance' },
  { title: 'Differential Crush Sleeve Tool', description: 'Tool for installing crush sleeves in differentials' },
  { title: 'Differential Shim Kit', description: 'Complete shim kit for setting differential gear backlash' },
  { title: 'Differential Pinion Depth Tool', description: 'Tool for measuring pinion depth in differentials' },
  { title: 'Differential Bearing Kit', description: 'Complete bearing kit for rebuilding differentials' },
  { title: 'Axle Puller', description: 'Tool for pulling axles from vehicles' },
  { title: 'Axle Shaft Seal Installer', description: 'Tool for installing axle shaft seals' },
  { title: 'Hub Bearing Press', description: 'Press for installing and removing hub bearings' },
  { title: 'Wheel Bearing Press', description: 'Press for installing and removing wheel bearings' },
  { title: 'Wheel Hub Puller', description: 'Tool for removing wheel hubs from vehicles' },
  { title: 'Wheel Hub Installer', description: 'Tool for installing wheel hubs' },
  { title: 'Wheel Alignment Tool', description: 'Tool for checking and adjusting wheel alignment' },
  { title: 'Brake Rotor Puller', description: 'Tool for removing brake rotors from vehicles' },
  { title: 'Brake Caliper Tool Kit', description: 'Complete tool kit for servicing brake calipers' },
  { title: 'Wheel Balancer', description: 'Tool for balancing vehicle wheels' },
  { title: 'Tire Changer', description: 'Machine for changing vehicle tires' },
  { title: 'Tire Bead Breaker', description: 'Tool for breaking the bead on vehicle tires' },
  { title: 'Tire Valve Stem Tool', description: 'Tool for installing and removing tire valve stems' },
  { title: 'Tire Plug Kit', description: 'Complete tire plug kit for repairing punctured tires' },
  { title: 'Wheel Lock Removal Tool', description: 'Tool for removing wheel locks' },
  { title: 'Tire Pressure Gauge', description: 'Portable tire pressure gauge for checking tire pressure' },
  { title: 'Tire Inflator', description: 'Air-powered tire inflator for automotive use' },
  { title: 'Tire Patch Kit', description: 'Complete tire patch kit for repairing flat tires' },
  { title: 'Tire Plug Gun', description: 'Tool for quickly installing tire plugs' },
  { title: 'Tire Spreader', description: 'Tool for spreading tires during repairs' },
  { title: 'Tire Repair Kit', description: 'Complete tire repair kit for automotive use' },
  { title: 'Wheel Stud Installer', description: 'Tool for installing wheel studs' },
  { title: 'Wheel Stud Extractor', description: 'Tool for extracting broken wheel studs' },
  { title: 'Wheel Stud Press', description: 'Press for installing and removing wheel studs' },
  { title: 'Wheel Spacer', description: 'Wheel spacer for adjusting wheel offset' },
  { title: 'Lug Nut Socket Set', description: 'Complete lug nut socket set for automotive work' },
  { title: 'Lug Wrench', description: 'Heavy-duty lug wrench for removing lug nuts' },
  { title: 'Torque Stick Set', description: 'Set of torque sticks for automotive work' },
  { title: 'Impact Socket Set', description: 'Complete impact socket set for automotive work' },
  { title: 'Chrome Socket Set', description: 'Chrome-plated socket set for automotive work' },
  { title: 'Axle Nut Socket Set', description: 'Complete axle nut socket set for automotive work' },
  { title: 'Hub Nut Socket Set', description: 'Complete hub nut socket set for automotive work' },
  { title: 'Oil Filter Socket Set', description: 'Complete oil filter socket set for automotive work' },
  { title: 'Spark Plug Socket Set', description: 'Complete spark plug socket set for automotive work' },
  { title: 'Fuel Line Disconnect Tool', description: 'Tool for disconnecting fuel lines' },
  { title: 'AC Line Disconnect Tool', description: 'Tool for disconnecting AC lines' },
  { title: 'Heater Hose Disconnect Tool', description: 'Tool for disconnecting heater hoses' },
  { title: 'Coolant Pressure Tester', description: 'Tester for checking coolant pressure' },
  { title: 'Radiator Cap Tester', description: 'Tester for checking radiator caps' },
  { title: 'Radiator Hose Clamp Tool', description: 'Tool for removing and installing radiator hose clamps' },
  { title: 'Coolant Flush Kit', description: 'Complete coolant flush kit for automotive use' },
  { title: 'Coolant Refill Kit', description: 'Complete coolant refill kit for automotive use' },
  { title: 'Thermostat Tester', description: 'Tester for checking thermostat operation' },
  { title: 'Water Pump Tester', description: 'Tester for checking water pump operation' },
  { title: 'Timing Belt Tool Kit', description: 'Complete timing belt tool kit for automotive use' },
  { title: 'Timing Chain Tool Kit', description: 'Complete timing chain tool kit for automotive use' },
  { title: 'Crankshaft Positioning Tool', description: 'Tool for positioning crankshafts during timing' },
  { title: 'Camshaft Positioning Tool', description: 'Tool for positioning camshafts during timing' },
  { title: 'Crankshaft Pulley Tool Kit', description: 'Complete crankshaft pulley tool kit for automotive use' },
  { title: 'Camshaft Pulley Tool Kit', description: 'Complete camshaft pulley tool kit for automotive use' },
  { title: 'Harmonic Balancer Puller', description: 'Tool for removing harmonic balancers' },
  { title: 'Crankshaft Balancer Installer', description: 'Tool for installing crankshaft balancers' },
  { title: 'Engine Timing Tool Kit', description: 'Complete engine timing tool kit for automotive use' },
  { title: 'Timing Belt Tensioner Tool', description: 'Tool for adjusting timing belt tensioners' },
  { title: 'Timing Chain Tensioner Tool', description: 'Tool for adjusting timing chain tensioners' },
  { title: 'Camshaft Locking Tool', description: 'Tool for locking camshafts during timing' },
  { title: 'Valve Spring Compressor Tool', description: 'Tool for compressing valve springs' },
  { title: 'Piston Ring Installation Tool', description: 'Tool for installing piston rings' },
  { title: 'Valve Guide Installation Tool', description: 'Tool for installing valve guides' },
  { title: 'Valve Seal Installation Tool', description: 'Tool for installing valve seals' },
  { title: 'Valve Lapping Tool', description: 'Tool for lapping valves during engine rebuilds' },
  { title: 'Cylinder Head Installation Tool', description: 'Tool for installing cylinder heads' },
  { title: 'Crankshaft Installation Tool', description: 'Tool for installing crankshafts' },
  { title: 'Connecting Rod Installation Tool', description: 'Tool for installing connecting rods' },
  { title: 'Main Bearing Installation Tool', description: 'Tool for installing main bearings' },
  { title: 'Piston Installation Tool', description: 'Tool for installing pistons' },
  { title: 'Timing Gear Installation Tool', description: 'Tool for installing timing gears' },
  { title: 'Crankshaft Gear Installation Tool', description: 'Tool for installing crankshaft gears' },
  { title: 'Camshaft Gear Installation Tool', description: 'Tool for installing camshaft gears' },
  { title: 'Oil Pump Installation Tool', description: 'Tool for installing oil pumps' },
  { title: 'Water Pump Installation Tool', description: 'Tool for installing water pumps' },
  { title: 'Fuel Pump Installation Tool', description: 'Tool for installing fuel pumps' },
  { title: 'Exhaust Manifold Installation Tool', description: 'Tool for installing exhaust manifolds' },
  { title: 'Intake Manifold Installation Tool', description: 'Tool for installing intake manifolds' },
  { title: 'Turbocharger Installation Tool', description: 'Tool for installing turbochargers' },
  { title: 'Supercharger Installation Tool', description: 'Tool for installing superchargers'}
],

'Automotive Parts & Accessories' => [
  { title: 'Car Battery', description: 'Long-lasting car battery' },
  { title: 'Brake Pads', description: 'High-quality brake pads for cars' },
  { title: 'Oil Filter', description: 'Filter for cleaning engine oil' },
  { title: 'Air Filter', description: 'Filter for cleaning air entering the engine' },
  { title: 'Fuel Filter', description: 'Filter for cleaning fuel' },
  { title: 'Spark Plugs', description: 'Spark plugs for ignition systems' },
  { title: 'Headlights', description: 'Replacement headlights for vehicles' },
  { title: 'Tail Lights', description: 'Replacement tail lights for vehicles' },
  { title: 'Alternator', description: 'Alternator for charging the vehicle battery' },
  { title: 'Starter Motor', description: 'Starter motor for starting the engine' },
  { title: 'Water Pump', description: 'Water pump for cooling system' },
  { title: 'Radiator', description: 'Radiator for cooling the engine' },
  { title: 'Timing Belt', description: 'Timing belt for engine synchronization' },
  { title: 'Timing Chain', description: 'Timing chain for engine synchronization' },
  { title: 'Transmission Filter', description: 'Filter for cleaning transmission fluid' },
  { title: 'Power Steering Pump', description: 'Pump for power steering system' },
  { title: 'Brake Rotors', description: 'Rotors for braking system' },
  { title: 'Clutch Kit', description: 'Complete clutch kit for manual transmission' },
  { title: 'Suspension Struts', description: 'Suspension struts for vehicle stability' },
  { title: 'Shock Absorbers', description: 'Shock absorbers for smooth driving' },
  { title: 'Fuel Pump', description: 'Pump for delivering fuel to the engine' },
  { title: 'Battery Charger', description: 'Charger for maintaining car battery' },
  { title: 'Car Filters', description: 'Various filters for vehicle maintenance' },
  { title: 'Brake Calipers', description: 'Calipers for the braking system' },
  { title: 'Wheel Bearings', description: 'Bearings for wheel rotation' },
  { title: 'Drive Belts', description: 'Belts for powering accessories' },
  { title: 'Serpentine Belt', description: 'Belt for driving multiple accessories' },
  { title: 'Fuel Injectors', description: 'Injectors for delivering fuel into the engine' },
  { title: 'Radiator Hoses', description: 'Hoses for connecting radiator to engine' },
  { title: 'Thermostat', description: 'Thermostat for regulating engine temperature' },
  { title: 'Cylinder Head', description: 'Head for engine cylinder block' },
  { title: 'Engine Block', description: 'Engine block for housing engine components' },
  { title: 'Piston Rings', description: 'Rings for sealing pistons in the engine' },
  { title: 'Crankshaft', description: 'Crankshaft for converting piston movement' },
  { title: 'Camshaft', description: 'Camshaft for operating engine valves' },
  { title: 'Turbocharger', description: 'Turbocharger for increasing engine power' },
  { title: 'Supercharger', description: 'Supercharger for boosting engine performance' },
  { title: 'Exhaust Manifold', description: 'Manifold for directing exhaust gases' },
  { title: 'Intake Manifold', description: 'Manifold for distributing air-fuel mixture' },
  { title: 'Catalytic Converter', description: 'Converter for reducing exhaust emissions' },
  { title: 'Oxygen Sensors', description: 'Sensors for monitoring exhaust gases' },
  { title: 'Mass Air Flow Sensor', description: 'Sensor for measuring air flow into the engine' },
  { title: 'Idle Air Control Valve', description: 'Valve for controlling engine idle speed' },
  { title: 'PCV Valve', description: 'Valve for controlling crankcase ventilation' },
  { title: 'EGR Valve', description: 'Valve for recirculating exhaust gases' },
  { title: 'Fuel Tank', description: 'Tank for storing fuel' },
  { title: 'Fuel Tank Sender', description: 'Sender for fuel level measurement' },
  { title: 'Fuel Filler Cap', description: 'Cap for sealing the fuel tank' },
  { title: 'Power Window Motor', description: 'Motor for operating power windows' },
  { title: 'Door Lock Actuator', description: 'Actuator for locking and unlocking doors' },
  { title: 'Window Regulator', description: 'Regulator for operating window movement' },
  { title: 'Ignition Coil', description: 'Coil for igniting the air-fuel mixture' },
  { title: 'Distributor Cap', description: 'Cap for distributing electrical current' },
  { title: 'Rotor Arm', description: 'Arm for distributing electrical current' },
  { title: 'Wiper Blades', description: 'Blades for cleaning the windshield' },
  { title: 'Wiper Motor', description: 'Motor for operating windshield wipers' },
  { title: 'Windshield Washer Pump', description: 'Pump for windshield washer fluid' },
  { title: 'Head Gasket', description: 'Gasket for sealing the engine head' },
  { title: 'Valve Cover Gasket', description: 'Gasket for sealing the valve cover' },
  { title: 'Oil Pan Gasket', description: 'Gasket for sealing the oil pan' },
  { title: 'Transmission Pan Gasket', description: 'Gasket for sealing the transmission pan' },
  { title: 'Differential Fluid', description: 'Fluid for lubricating the differential' },
  { title: 'Gear Oil', description: 'Oil for lubricating gear systems' },
  { title: 'Transmission Fluid', description: 'Fluid for transmission lubrication' },
  { title: 'Brake Fluid', description: 'Fluid for the braking system' },
  { title: 'Coolant', description: 'Coolant for engine temperature regulation' },
  { title: 'Engine Oil', description: 'Oil for engine lubrication' },
  { title: 'Cabin Air Filter', description: 'Filter for air inside the vehicle cabin' },
  { title: 'Engine Mounts', description: 'Mounts for securing the engine' },
  { title: 'Transmission Mounts', description: 'Mounts for securing the transmission' },
  { title: 'Suspension Bushings', description: 'Bushings for suspension system' },
  { title: 'Tie Rod Ends', description: 'Ends for steering linkage' },
  { title: 'Ball Joints', description: 'Joints for suspension and steering' },
  { title: 'Control Arms', description: 'Arms for controlling wheel movement' },
  { title: 'Strut Mounts', description: 'Mounts for struts in the suspension' },
  { title: 'Shock Absorber Mounts', description: 'Mounts for shock absorbers' },
  { title: 'Leaf Springs', description: 'Springs for vehicle suspension' },
  { title: 'Coil Springs', description: 'Springs for vehicle suspension' },
  { title: 'Anti-Sway Bars', description: 'Bars for reducing body roll' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power from the engine' },
  { title: 'Axle Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Differential Gears', description: 'Gears for the differential system' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Oil Cooler', description: 'Cooler for regulating engine oil temperature' },
  { title: 'Transmission Cooler', description: 'Cooler for regulating transmission fluid temperature' },
  { title: 'Intercooler', description: 'Cooler for reducing intake air temperature' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Rebuild Kits', description: 'Kits for rebuilding engines' },
  { title: 'Cylinder Heads', description: 'Heads for engine cylinders' },
  { title: 'Pistons', description: 'Pistons for engine cylinders' },
  { title: 'Connecting Rods', description: 'Rods for connecting pistons to the crankshaft' },
  { title: 'Crankshafts', description: 'Crankshafts for converting piston movement' },
  { title: 'Camshafts', description: 'Camshafts for operating engine valves' },
  { title: 'Water Pump Pulley', description: 'Pulley for driving the water pump' },
  { title: 'Alternator Pulley', description: 'Pulley for driving the alternator' },
  { title: 'Power Steering Pulley', description: 'Pulley for driving the power steering pump' },
  { title: 'Timing Belt Tensioners', description: 'Tensioners for timing belts' },
  { title: 'Timing Chain Tensioners', description: 'Tensioners for timing chains' },
  { title: 'Accessory Drive Belts', description: 'Belts for driving engine accessories' },
  { title: 'Serpentine Belts', description: 'Belts for driving multiple accessories' },
  { title: 'Fuel Pressure Regulators', description: 'Regulators for controlling fuel pressure' },
  { title: 'Oil Pressure Switches', description: 'Switches for monitoring oil pressure' },
  { title: 'Coolant Temperature Sensors', description: 'Sensors for monitoring coolant temperature' },
  { title: 'Throttle Position Sensors', description: 'Sensors for monitoring throttle position' },
  { title: 'Mass Air Flow Sensors', description: 'Sensors for measuring air flow into the engine' },
  { title: 'Camshaft Sensors', description: 'Sensors for monitoring camshaft position' },
  { title: 'Crankshaft Sensors', description: 'Sensors for monitoring crankshaft position' },
  { title: 'Vehicle Speed Sensors', description: 'Sensors for measuring vehicle speed' },
  { title: 'ABS Sensors', description: 'Sensors for anti-lock braking systems' },
  { title: 'TPMS Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Oxygen Sensor Socket', description: 'Socket for removing oxygen sensors' },
  { title: 'Spark Plug Socket', description: 'Socket for removing spark plugs' },
  { title: 'Glow Plugs', description: 'Plugs for warming diesel engine cylinders' },
  { title: 'Injector Nozzles', description: 'Nozzles for fuel injectors' },
  { title: 'Fuel Tank Straps', description: 'Straps for securing the fuel tank' },
  { title: 'Fuel Pump Relays', description: 'Relays for operating the fuel pump' },
  { title: 'Fuse Boxes', description: 'Boxes for housing electrical fuses' },
  { title: 'Wiring Harnesses', description: 'Harnesses for electrical wiring' },
  { title: 'Battery Cables', description: 'Cables for connecting the car battery' },
  { title: 'Starter Solenoids', description: 'Solenoids for operating the starter motor' },
  { title: 'Alternator Regulators', description: 'Regulators for controlling alternator output' },
  { title: 'Voltage Regulators', description: 'Regulators for controlling electrical voltage' },
  { title: 'Headlight Bulbs', description: 'Bulbs for headlights' },
  { title: 'Tail Light Bulbs', description: 'Bulbs for tail lights' },
  { title: 'Fog Light Bulbs', description: 'Bulbs for fog lights' },
  { title: 'Turn Signal Bulbs', description: 'Bulbs for turn signals' },
  { title: 'Interior Light Bulbs', description: 'Bulbs for interior lighting' },
  { title: 'License Plate Lights', description: 'Lights for illuminating license plates' },
  { title: 'Hood Struts', description: 'Struts for holding up the hood' },
  { title: 'Trunk Struts', description: 'Struts for holding up the trunk' },
  { title: 'Door Handles', description: 'Handles for opening vehicle doors' },
  { title: 'Window Regulators', description: 'Regulators for operating window movement' },
  { title: 'Mirror Assemblies', description: 'Assemblies for side mirrors' },
  { title: 'Door Panels', description: 'Panels for vehicle doors' },
  { title: 'Carpet Kits', description: 'Kits for replacing vehicle carpets' },
  { title: 'Seat Covers', description: 'Covers for vehicle seats' },
  { title: 'Floor Mats', description: 'Mats for protecting vehicle floors' },
  { title: 'Dashboard Covers', description: 'Covers for protecting dashboards' },
  { title: 'Sun Visors', description: 'Visors for blocking sunlight' },
  { title: 'Steering Wheels', description: 'Wheels for steering the vehicle' },
  { title: 'Gear Shift Knobs', description: 'Knobs for shifting gears' },
  { title: 'Pedal Covers', description: 'Covers for vehicle pedals' },
  { title: 'Horn Kits', description: 'Kits for installing vehicle horns' },
  { title: 'Wiper Arms', description: 'Arms for holding windshield wipers' },
  { title: 'Wiper Blades', description: 'Blades for cleaning windshields' },
  { title: 'Windshield Washer Reservoirs', description: 'Reservoirs for windshield washer fluid' },
  { title: 'Fuel Tank Caps', description: 'Caps for sealing the fuel tank' },
  { title: 'Gas Tank Covers', description: 'Covers for protecting the gas tank' },
  { title: 'Exhaust Systems', description: 'Systems for controlling exhaust gases' },
  { title: 'Mufflers', description: 'Mufflers for reducing exhaust noise' },
  { title: 'Exhaust Pipes', description: 'Pipes for directing exhaust gases' },
  { title: 'Catalytic Converters', description: 'Converters for reducing emissions' },
  { title: 'Turbochargers', description: 'Turbochargers for increasing engine power' },
  { title: 'Superchargers', description: 'Superchargers for boosting engine performance' },
  { title: 'Intercoolers', description: 'Intercoolers for cooling intake air' },
  { title: 'Engine Rebuild Kits', description: 'Kits for rebuilding engines' },
  { title: 'Cylinder Heads', description: 'Heads for engine cylinders' },
  { title: 'Pistons', description: 'Pistons for engine cylinders' },
  { title: 'Connecting Rods', description: 'Rods for connecting pistons to the crankshaft' },
  { title: 'Crankshafts', description: 'Crankshafts for converting piston movement' },
  { title: 'Camshafts', description: 'Camshafts for operating engine valves' },
  { title: 'Timing Belt Kits', description: 'Kits for replacing timing belts' },
  { title: 'Timing Chain Kits', description: 'Kits for replacing timing chains' },
  { title: 'Gasket Sets', description: 'Sets of gaskets for various engine components' },
  { title: 'Seal Kits', description: 'Kits for sealing engine and transmission components' },
  { title: 'Oil Pumps', description: 'Pumps for circulating engine oil' },
  { title: 'Water Pumps', description: 'Pumps for circulating coolant' },
  { title: 'Power Steering Pumps', description: 'Pumps for power steering systems' },
  { title: 'Transmission Pumps', description: 'Pumps for transmission systems' },
  { title: 'Differentials', description: 'Differentials for distributing power to wheels' },
  { title: 'Axles', description: 'Axles for transferring power from the differential' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Brake Lines', description: 'Lines for hydraulic brake systems' },
  { title: 'Fuel Lines', description: 'Lines for transporting fuel' },
  { title: 'Transmission Lines', description: 'Lines for transmission fluid' },
  { title: 'Power Steering Lines', description: 'Lines for power steering fluid' },
  { title: 'Radiator Hoses', description: 'Hoses for connecting radiator to engine' },
  { title: 'Vacuum Hoses', description: 'Hoses for vacuum systems' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Mounts', description: 'Mounts for securing the engine' },
  { title: 'Transmission Mounts', description: 'Mounts for securing the transmission' },
  { title: 'Suspension Bushings', description: 'Bushings for suspension system' },
  { title: 'Tie Rod Ends', description: 'Ends for steering linkage' },
  { title: 'Ball Joints', description: 'Joints for suspension and steering' },
  { title: 'Control Arms', description: 'Arms for controlling wheel movement' },
  { title: 'Strut Mounts', description: 'Mounts for struts in the suspension' },
  { title: 'Shock Absorber Mounts', description: 'Mounts for shock absorbers' },
  { title: 'Leaf Springs', description: 'Springs for vehicle suspension' },
  { title: 'Coil Springs', description: 'Springs for vehicle suspension' },
  { title: 'Anti-Sway Bars', description: 'Bars for reducing body roll' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power from the engine' },
  { title: 'Axle Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Differential Gears', description: 'Gears for the differential system' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Oil Coolers', description: 'Coolers for regulating engine oil temperature' },
  { title: 'Transmission Coolers', description: 'Coolers for regulating transmission fluid temperature' },
  { title: 'Intercoolers', description: 'Coolers for reducing intake air temperature' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Rebuild Kits', description: 'Kits for rebuilding engines' },
  { title: 'Cylinder Heads', description: 'Heads for engine cylinders' },
  { title: 'Pistons', description: 'Pistons for engine cylinders' },
  { title: 'Connecting Rods', description: 'Rods for connecting pistons to the crankshaft' },
  { title: 'Crankshafts', description: 'Crankshafts for converting piston movement' },
  { title: 'Camshafts', description: 'Camshafts for operating engine valves' },
  { title: 'Timing Belt Kits', description: 'Kits for replacing timing belts' },
  { title: 'Timing Chain Kits', description: 'Kits for replacing timing chains' },
  { title: 'Gasket Sets', description: 'Sets of gaskets for various engine components' },
  { title: 'Seal Kits', description: 'Kits for sealing engine and transmission components' },
  { title: 'Oil Pumps', description: 'Pumps for circulating engine oil' },
  { title: 'Water Pumps', description: 'Pumps for circulating coolant' },
  { title: 'Power Steering Pumps', description: 'Pumps for power steering systems' },
  { title: 'Transmission Pumps', description: 'Pumps for transmission systems' },
  { title: 'Differentials', description: 'Differentials for distributing power to wheels' },
  { title: 'Axles', description: 'Axles for transferring power from the differential' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Brake Lines', description: 'Lines for hydraulic brake systems' },
  { title: 'Fuel Lines', description: 'Lines for transporting fuel' },
  { title: 'Transmission Lines', description: 'Lines for transmission fluid' },
  { title: 'Power Steering Lines', description: 'Lines for power steering fluid' },
  { title: 'Radiator Hoses', description: 'Hoses for connecting radiator to engine' },
  { title: 'Vacuum Hoses', description: 'Hoses for vacuum systems' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Mounts', description: 'Mounts for securing the engine' },
  { title: 'Transmission Mounts', description: 'Mounts for securing the transmission' },
  { title: 'Suspension Bushings', description: 'Bushings for suspension system' },
  { title: 'Tie Rod Ends', description: 'Ends for steering linkage' },
  { title: 'Ball Joints', description: 'Joints for suspension and steering' },
  { title: 'Control Arms', description: 'Arms for controlling wheel movement' },
  { title: 'Strut Mounts', description: 'Mounts for struts in the suspension' },
  { title: 'Shock Absorber Mounts', description: 'Mounts for shock absorbers' },
  { title: 'Leaf Springs', description: 'Springs for vehicle suspension' },
  { title: 'Coil Springs', description: 'Springs for vehicle suspension' },
  { title: 'Anti-Sway Bars', description: 'Bars for reducing body roll' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power from the engine' },
  { title: 'Axle Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Differential Gears', description: 'Gears for the differential system' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Oil Coolers', description: 'Coolers for regulating engine oil temperature' },
  { title: 'Transmission Coolers', description: 'Coolers for regulating transmission fluid temperature' },
  { title: 'Intercoolers', description: 'Coolers for reducing intake air temperature' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Rebuild Kits', description: 'Kits for rebuilding engines' },
  { title: 'Cylinder Heads', description: 'Heads for engine cylinders' },
  { title: 'Pistons', description: 'Pistons for engine cylinders' },
  { title: 'Connecting Rods', description: 'Rods for connecting pistons to the crankshaft' },
  { title: 'Crankshafts', description: 'Crankshafts for converting piston movement' },
  { title: 'Camshafts', description: 'Camshafts for operating engine valves' },
  { title: 'Timing Belt Kits', description: 'Kits for replacing timing belts' },
  { title: 'Timing Chain Kits', description: 'Kits for replacing timing chains' },
  { title: 'Gasket Sets', description: 'Sets of gaskets for various engine components' },
  { title: 'Seal Kits', description: 'Kits for sealing engine and transmission components' },
  { title: 'Oil Pumps', description: 'Pumps for circulating engine oil' },
  { title: 'Water Pumps', description: 'Pumps for circulating coolant' },
  { title: 'Power Steering Pumps', description: 'Pumps for power steering systems' },
  { title: 'Transmission Pumps', description: 'Pumps for transmission systems' },
  { title: 'Differentials', description: 'Differentials for distributing power to wheels' },
  { title: 'Axles', description: 'Axles for transferring power from the differential' },
  { title: 'Drive Shafts', description: 'Shafts for transferring power to the wheels' },
  { title: 'Wheel Hubs', description: 'Hubs for mounting wheels' },
  { title: 'Wheel Studs', description: 'Studs for securing wheels' },
  { title: 'Lug Nuts', description: 'Nuts for securing wheels' },
  { title: 'Wheel Spacers', description: 'Spacers for adjusting wheel offset' },
  { title: 'Tire Pressure Sensors', description: 'Sensors for monitoring tire pressure' },
  { title: 'Brake Lines', description: 'Lines for hydraulic brake systems' },
  { title: 'Fuel Lines', description: 'Lines for transporting fuel' },
  { title: 'Transmission Lines', description: 'Lines for transmission fluid' },
  { title: 'Power Steering Lines', description: 'Lines for power steering fluid' },
  { title: 'Radiator Hoses', description: 'Hoses for connecting radiator to engine' },
  { title: 'Vacuum Hoses', description: 'Hoses for vacuum systems' },
  { title: 'Turbocharger Kits', description: 'Kits for installing turbochargers' },
  { title: 'Supercharger Kits', description: 'Kits for installing superchargers' },
  { title: 'Engine Mounts', description: 'Mounts for securing the engine' },
  { title: 'Transmission Mounts', description: 'Mounts for securing the transmission' },
  { title: 'Suspension Bushings', description: 'Bushings for suspension system' },
  { title: 'Tie Rod Ends', description: 'Ends for steering linkage' },
  { title: 'Ball Joints', description: 'Joints for suspension and steering' },
  { title: 'Control Arms', description: 'Arms for controlling wheel movement' },
  { title: 'Strut Mounts', description: 'Mounts for struts in the suspension' },
  { title: 'Shock Absorber Mounts', description: 'Mounts for shock absorbers' },
  { title: 'Leaf Springs', description: 'Springs for vehicle suspension' },
  { title: 'Coil Springs', description: 'Springs for vehicle suspension' },
  { title: 'Anti-Sway Bars', description: 'Bars for reducing body roll' }
],

'Computer Parts & Accessories' => [
  { title: 'Graphics Card', description: 'High-performance graphics card for gaming' },
  { title: 'RAM Module', description: '8GB RAM module for computers' },
  { title: 'Solid State Drive', description: '500GB SSD for faster storage' },
  { title: 'Hard Disk Drive', description: '1TB HDD for additional storage' },
  { title: 'Motherboard', description: 'ATX motherboard with multiple ports' },
  { title: 'Processor', description: 'Intel i7 processor for high-speed computing' },
  { title: 'Power Supply Unit', description: '650W PSU for reliable power delivery' },
  { title: 'CPU Cooler', description: 'High-performance CPU cooler for overclocking' },
  { title: 'Computer Case', description: 'Mid-tower case with cable management' },
  { title: 'Gaming Keyboard', description: 'Mechanical keyboard with RGB lighting' },
  { title: 'Gaming Mouse', description: 'Ergonomic mouse with customizable DPI settings' },
  { title: 'Monitor', description: '27-inch 4K monitor for sharp visuals' },
  { title: 'Headset', description: 'Gaming headset with surround sound' },
  { title: 'Webcam', description: '1080p webcam for clear video calls' },
  { title: 'External Hard Drive', description: '2TB external drive for backup' },
  { title: 'USB Hub', description: '7-port USB hub for connecting multiple devices' },
  { title: 'Optical Drive', description: 'DVD-RW drive for reading and writing discs' },
  { title: 'Network Card', description: 'Dual-band Wi-Fi card for faster internet' },
  { title: 'Sound Card', description: 'External sound card for enhanced audio quality' },
  { title: 'Cooling Fan', description: '120mm cooling fan for improved airflow' },
  { title: 'Thermal Paste', description: 'High-performance thermal paste for CPUs' },
  { title: 'Mouse Pad', description: 'Large mouse pad with smooth surface' },
  { title: 'Power Strip', description: 'Surge-protected power strip with USB ports' },
  { title: 'Cable Management Kit', description: 'Kit for organizing cables and wires' },
  { title: 'Computer Stand', description: 'Adjustable stand for ergonomic positioning' },
  { title: 'Docking Station', description: 'Docking station for connecting multiple peripherals' },
  { title: 'Bluetooth Adapter', description: 'Bluetooth adapter for wireless connectivity' },
  { title: 'Case Fans', description: 'Set of case fans for cooling' },
  { title: 'External SSD', description: '1TB external SSD for fast storage' },
  { title: 'Thermal Paste Cleaner', description: 'Cleaner for removing old thermal paste' },
  { title: 'BIOS Battery', description: 'Replacement battery for motherboard BIOS' },
  { title: 'CPU Thermal Pad', description: 'Thermal pad for CPU cooling' },
  { title: 'Laptop Docking Station', description: 'Docking station for laptops with multiple ports' },
  { title: 'Wireless Keyboard', description: 'Wireless keyboard with quiet keys' },
  { title: 'Wireless Mouse', description: 'Wireless mouse with long battery life' },
  { title: 'Multi-Monitor Stand', description: 'Stand for holding multiple monitors' },
  { title: 'Portable Monitor', description: '15.6-inch portable monitor for on-the-go use' },
  { title: 'USB Flash Drive', description: '32GB USB flash drive for data transfer' },
  { title: 'External Optical Drive', description: 'External DVD drive for laptops' },
  { title: 'Laptop Cooling Pad', description: 'Cooling pad for laptops with fans' },
  { title: 'VR Headset', description: 'Virtual reality headset for immersive experiences' },
  { title: 'Cable Sleeving Kit', description: 'Kit for customizing and organizing cables' },
  { title: 'USB to Ethernet Adapter', description: 'Adapter for adding Ethernet connectivity via USB' },
  { title: 'PCIe Expansion Card', description: 'Expansion card for additional PCIe slots' },
  { title: 'M.2 SSD', description: '500GB M.2 SSD for ultra-fast storage' },
  { title: 'Memory Card Reader', description: 'Reader for various memory card formats' },
  { title: 'PC Cleaning Kit', description: 'Kit for cleaning and maintaining your PC' },
  { title: 'Digital Pen Tablet', description: 'Tablet for digital drawing and note-taking' },
  { title: 'Microphone', description: 'High-quality microphone for recording and streaming' },
  { title: 'Laptop Case', description: 'Protective case for laptops' },
  { title: 'Mouse Bungee', description: 'Bungee for managing mouse cable' },
  { title: 'Laptop Stand', description: 'Adjustable stand for laptop ergonomics' },
  { title: 'Graphics Card Stand', description: 'Stand for stabilizing large graphics cards' },
  { title: 'Memory Heat Spreader', description: 'Heat spreader for RAM modules' },
  { title: 'Cooling System', description: 'Advanced cooling system for high-performance PCs' },
  { title: 'Computer Dust Filter', description: 'Filter for keeping dust out of your PC case' },
  { title: 'USB-C Hub', description: 'Hub for expanding USB-C connectivity' },
  { title: 'KVM Switch', description: 'Switch for controlling multiple computers with one set of peripherals' },
  { title: 'Network Switch', description: 'Network switch for expanding Ethernet connections' },
  { title: 'Power Supply Tester', description: 'Tester for checking power supply functionality' },
  { title: 'Cable Tester', description: 'Tester for diagnosing cable issues' },
  { title: 'Replacement Laptop Battery', description: 'Battery replacement for laptops' },
  { title: 'Battery Charger', description: 'Charger for rechargeable batteries' },
  { title: 'Wi-Fi Range Extender', description: 'Device for extending Wi-Fi coverage' },
  { title: 'Bluetooth Speaker', description: 'Portable Bluetooth speaker with high sound quality' },
  { title: 'USB Printer Cable', description: 'Cable for connecting printers via USB' },
  { title: 'Docking Station for Desktop', description: 'Docking station for expanding desktop connectivity' },
  { title: 'Power Supply Mounting Brackets', description: 'Brackets for mounting power supplies' },
  { title: 'Cable Management Clips', description: 'Clips for securing and organizing cables' },
  { title: 'Fan Controller', description: 'Controller for managing case fans' },
  { title: 'RGB Lighting Kit', description: 'Kit for adding RGB lighting to your PC' },
  { title: 'Computer Mouse Wrist Rest', description: 'Wrist rest for mouse comfort' },
  { title: 'Gaming Chair', description: 'Ergonomic chair designed for gamers' },
  { title: 'Desktop Organizer', description: 'Organizer for keeping your desk tidy' },
  { title: 'Cable Tie Kit', description: 'Kit of cable ties for securing wires' },
  { title: 'Power Cable', description: 'Replacement power cable for PCs' },
  { title: 'HDMI Cable', description: 'High-speed HDMI cable for video and audio' },
  { title: 'DisplayPort Cable', description: 'Cable for connecting monitors via DisplayPort' },
  { title: 'VGA Cable', description: 'Cable for connecting monitors via VGA' },
  { title: 'DVI Cable', description: 'Cable for connecting monitors via DVI' },
  { title: 'Adapter for HDMI to VGA', description: 'Adapter for converting HDMI to VGA' },
  { title: 'Adapter for USB to HDMI', description: 'Adapter for connecting USB to HDMI' },
  { title: 'Keyboard Cover', description: 'Cover to protect your keyboard from dust and spills' },
  { title: 'Laptop Screen Protector', description: 'Protector for preventing scratches on laptop screens' },
  { title: 'Screen Cleaning Kit', description: 'Kit for cleaning computer screens' },
  { title: 'Portable Power Bank', description: 'Power bank for charging devices on the go' },
  { title: 'Multi-Port Charger', description: 'Charger with multiple ports for simultaneous device charging' },
  { title: 'Wireless Charging Pad', description: 'Pad for charging devices wirelessly' },
  { title: 'USB Hub with SD Card Reader', description: 'USB hub with integrated SD card reader' },
  { title: 'Laptop Cooling Stand', description: 'Stand with built-in cooling fans for laptops' },
  { title: 'Desk Lamp', description: 'Adjustable desk lamp with LED light' },
  { title: 'Cable Management Sleeve', description: 'Sleeve for bundling and organizing cables' },
  { title: 'Bluetooth Keyboard', description: 'Bluetooth keyboard for wireless typing' },
  { title: 'Bluetooth Mouse', description: 'Bluetooth mouse for wireless use' },
  { title: 'Computer Repair Tool Kit', description: 'Kit with tools for repairing computers' },
  { title: 'Anti-Static Wrist Strap', description: 'Wrist strap for preventing static discharge' },
  { title: 'Heat Gun', description: 'Heat gun for various repair and crafting tasks' },
  { title: 'Screwdriver Set with Magnetic Tips', description: 'Magnetic screwdriver set for easy handling' },
  { title: 'Precision Tool Kit', description: 'Precision tools for detailed work on electronics' },
  { title: 'Electric Soldering Iron', description: 'Soldering iron for electronics repairs' },
  { title: 'Desoldering Pump', description: 'Pump for removing solder' },
  { title: 'Solder Wire', description: 'Wire for soldering electronic components' },
  { title: 'Heat Sink Paste', description: 'Paste for improving heat transfer from chips' },
  { title: 'Thermal Adhesive', description: 'Adhesive for bonding heat sinks to chips' },
  { title: 'Dust Blower', description: 'Blower for removing dust from computer components' },
  { title: 'Cable Crimper', description: 'Tool for crimping cables and connectors' },
  { title: 'Network Cable Tester', description: 'Tester for network cables' },
  { title: 'Pin Removal Tool', description: 'Tool for removing pins from connectors' },
  { title: 'LCD Screen Replacement', description: 'Replacement screen for LCD monitors' },
  { title: 'Computer Case Modding Kit', description: 'Kit for customizing and modding computer cases' },
  { title: 'Cable Spool', description: 'Spool of cable for DIY projects' },
  { title: 'Cable Strip Tool', description: 'Tool for stripping cables' },
  { title: 'PC Building Tool Kit', description: 'Kit of tools for assembling PCs' },
  { title: 'Power Supply Cable Sleeves', description: 'Sleeves for organizing power supply cables' },
  { title: 'Cooling Fan Filters', description: 'Filters for keeping cooling fans clean' },
  { title: 'Fan Speed Controller', description: 'Controller for adjusting fan speeds' },
  { title: 'Computer Fan Grill', description: 'Grill for protecting cooling fans' },
  { title: 'Water Cooling Kit', description: 'Kit for water cooling PC components' },
  { title: 'Reservoir for Water Cooling', description: 'Reservoir for holding coolant in water cooling systems' },
  { title: 'Radiator for Water Cooling', description: 'Radiator for dissipating heat in water cooling systems' },
  { title: 'Pump for Water Cooling', description: 'Pump for circulating coolant in water cooling systems' },
  { title: 'Water Block for CPU', description: 'Water block for cooling CPU in water cooling systems' },
  { title: 'Water Block for GPU', description: 'Water block for cooling GPU in water cooling systems' },
  { title: 'Coolant for Water Cooling', description: 'Coolant for use in water cooling systems' },
  { title: 'LED Strip Lighting for PC', description: 'LED strips for adding lighting effects to your PC' },
  { title: 'Cable Comb Set', description: 'Set of combs for organizing cables' },
  { title: 'PCIe Risers', description: 'Risers for mounting PCIe cards vertically' },
  { title: 'VGA to HDMI Adapter', description: 'Adapter for converting VGA to HDMI' },
  { title: 'HDMI Splitter', description: 'Splitter for sending HDMI signal to multiple displays' },
  { title: 'DisplayPort to HDMI Adapter', description: 'Adapter for converting DisplayPort to HDMI' },
  { title: 'USB to VGA Adapter', description: 'Adapter for converting USB to VGA' },
  { title: 'USB to DisplayPort Adapter', description: 'Adapter for converting USB to DisplayPort' },
  { title: 'Monitor Mount', description: 'Mount for attaching monitors to desks or walls' },
  { title: 'Cable Management Box', description: 'Box for hiding and organizing cables' },
  { title: 'Cable Management Clips with Adhesive', description: 'Adhesive clips for securing cables' },
  { title: 'Computer Cooling System', description: 'Complete system for cooling PC components' },
  { title: 'External USB Hub', description: 'External hub for expanding USB ports' },
  { title: 'Portable External Drive', description: 'Portable drive for backing up data' },
  { title: 'USB-C to USB Adapter', description: 'Adapter for connecting USB-C devices to USB ports' },
  { title: 'Multi-Function Printer', description: 'Printer with scanning and copying capabilities' },
  { title: 'High-Speed Ethernet Cable', description: 'Ethernet cable for fast network connections' },
  { title: 'Network Switch with PoE', description: 'Network switch with Power over Ethernet support' },
  { title: 'Server Rack Mount', description: 'Rack mount for server equipment' },
  { title: 'UPS Battery Backup', description: 'Uninterruptible power supply for protecting against outages' },
  { title: 'Data Storage Enclosure', description: 'Enclosure for housing data storage drives' },
  { title: 'Digital Thermometer for PC', description: 'Thermometer for monitoring PC temperatures' },
  { title: 'Gaming Headset Stand', description: 'Stand for holding gaming headsets' },
  { title: 'Ergonomic Chair Mat', description: 'Mat for protecting floors and improving chair mobility' },
  { title: 'USB Hub with Power Switch', description: 'USB hub with individual power switches for each port' },
  { title: 'Dual Monitor Stand', description: 'Stand for holding two monitors' },
  { title: 'Laptop Privacy Screen', description: 'Screen for protecting privacy on laptops' },
  { title: 'Digital Pen for Tablets', description: 'Pen for use with digital drawing tablets' },
  { title: 'USB-C Docking Station', description: 'Docking station for USB-C laptops' },
  { title: 'Cable Tie Mounts', description: 'Mounts for securing cable ties' },
  { title: 'Laptop Cooling Pad with USB Hub', description: 'Cooling pad with built-in USB hub' },
  { title: 'Replacement Laptop Charger', description: 'Charger for various laptop models' },
  { title: 'External GPU Enclosure', description: 'Enclosure for connecting external graphics cards' },
  { title: 'Thermal Paste Syringe', description: 'Syringe for applying thermal paste' },
  { title: 'Computer Assembly Tool Kit', description: 'Tool kit for building and assembling computers' },
  { title: 'Cable Management Clips with Velcro', description: 'Velcro clips for cable management' },
  { title: 'Magnetic Screwdriver Set', description: 'Set of screwdrivers with magnetic tips' },
  { title: 'Anti-Static Mat', description: 'Mat for preventing static discharge during repairs' },
  { title: 'Portable SSD Enclosure', description: 'Enclosure for portable SSDs' },
  { title: 'Smart Light Bulb', description: 'Smart bulb with adjustable brightness and color' },
  { title: 'Wi-Fi Mesh System', description: 'System for extending and improving Wi-Fi coverage' },
  { title: 'Dual Band Router', description: 'Router with dual-band support for better performance' },
  { title: 'USB to Ethernet Adapter', description: 'Adapter for connecting Ethernet via USB' },
  { title: 'Cable Management Sleeve with Velcro', description: 'Sleeve with Velcro for organizing cables' },
  { title: 'Desktop Charging Station', description: 'Station for charging multiple devices' },
  { title: 'LCD Monitor Stand', description: 'Stand for adjusting monitor height' },
  { title: 'Digital Pen Holder', description: 'Holder for digital pens and styluses' },
  { title: 'USB-C Power Adapter', description: 'Power adapter for USB-C devices' },
  { title: 'MicroSD Card', description: '64GB microSD card for expandable storage' },
  { title: 'High Capacity Power Bank', description: 'Power bank with high capacity for extended usage' },
  { title: 'Wireless Router with Modem', description: 'Router with integrated modem for internet access' },
  { title: 'Adjustable Monitor Stand', description: 'Stand with adjustable height for monitors' },
  { title: 'Portable USB Fan', description: 'USB-powered fan for cooling' },
  { title: 'Cable Management Ties', description: 'Ties for bundling and organizing cables' },
  { title: 'USB to HDMI Converter', description: 'Converter for connecting HDMI devices via USB' },
  { title: 'Multi-Port USB Charger', description: 'Charger with multiple USB ports for various devices' },
  { title: 'Cable Management Box with Lid', description: 'Box with lid for hiding and organizing cables' },
  { title: 'Screen Privacy Filter', description: 'Filter for protecting screen privacy' },
  { title: 'Replacement Computer Fans', description: 'Fans for replacing old or broken ones in your PC' },
  { title: 'Electronic Voltage Tester', description: 'Tester for checking electrical voltage' },
  { title: 'Mini Wireless Keyboard', description: 'Compact wireless keyboard with touchpad' },
  { title: 'Adjustable Laptop Stand', description: 'Stand for adjusting laptop height and angle' },
  { title: 'USB-C Hub with HDMI', description: 'Hub with HDMI output and multiple USB ports' },
  { title: 'Digital Audio Converter', description: 'Converter for digital audio signals' },
  { title: 'Laptop Power Brick', description: 'Power brick for various laptop models' },
  { title: 'External Blu-ray Drive', description: 'External drive for reading and writing Blu-ray discs' },
  { title: 'USB-C to USB-A Adapter', description: 'Adapter for connecting USB-A devices to USB-C ports' },
  { title: 'Smart Thermostat', description: 'Thermostat with smart features for controlling temperature' },
  { title: 'Smart Plug', description: 'Plug for controlling electrical devices remotely' },
  { title: 'Home Security Camera', description: 'Camera for monitoring home security' },
  { title: 'Wireless Charging Stand', description: 'Stand for charging devices wirelessly' },
  { title: 'Bluetooth Adapter for PC', description: 'Adapter for adding Bluetooth functionality to your PC' },
  { title: 'Wireless Network Adapter', description: 'Adapter for connecting to wireless networks' },
  { title: 'External Backup Battery', description: 'Battery for backing up power to external devices' },
  { title: 'USB-C to USB-B Adapter', description: 'Adapter for connecting USB-B devices to USB-C ports' },
  { title: 'Mechanical Keyboard Switches', description: 'Replacement switches for mechanical keyboards' },
  { title: 'USB-C Charging Cable', description: 'Cable for charging devices with USB-C ports' },
  { title: 'USB-C to MicroUSB Adapter', description: 'Adapter for connecting MicroUSB devices to USB-C ports' },
  { title: 'Portable External Battery Pack', description: 'External battery pack for portable power' },
  { title: 'Adjustable Cable Management Rack', description: 'Rack for adjusting and organizing cables' },
  { title: 'Computer Dust Blower', description: 'Blower for removing dust from computer components' },
  { title: 'USB-C Data Cable', description: 'Cable for transferring data via USB-C' },
  { title: 'USB-C Docking Station with Power Delivery', description: 'Docking station with power delivery for USB-C devices' },
  { title: 'Cable Management Clips with Magnetic Base', description: 'Clips with magnetic base for easy cable management' },
  { title: 'Portable USB-C SSD', description: 'Portable SSD with USB-C interface' },
  { title: 'HDMI Extender', description: 'Extender for HDMI signals over longer distances' },
  { title: 'USB-C Power Delivery Charger', description: 'Charger with USB-C power delivery' },
  { title: 'DisplayPort to DisplayPort Cable', description: 'Cable for connecting DisplayPort devices' },
  { title: 'Gaming Monitor Stand', description: 'Stand designed for gaming monitors' },
  { title: 'Cable Management Sleeves with Zip Closure', description: 'Sleeves with zip closure for secure cable management' },
  { title: 'High-Speed USB-C Hub', description: 'Hub with high-speed USB-C ports' },
  { title: 'USB-C Hub with Ethernet Port', description: 'Hub with Ethernet port and USB-C connectivity' },
  { title: 'USB-C to HDMI Cable', description: 'Cable for connecting USB-C devices to HDMI displays' },
  { title: 'Portable Wireless Keyboard', description: 'Portable keyboard with wireless connectivity' },
  { title: 'USB-C Docking Station with Ethernet', description: 'Docking station with Ethernet and USB-C ports' },
  { title: 'Gaming Chair with Speakers', description: 'Gaming chair with built-in speakers for immersive sound' },
  { title: 'Portable External Hard Drive with Encryption', description: 'External hard drive with built-in encryption' },
  { title: 'High-Capacity USB Flash Drive', description: 'USB flash drive with high storage capacity' },
  { title: 'Multi-Device Charging Station', description: 'Station for charging multiple devices simultaneously' },
  { title: 'Cable Management Pouches', description: 'Pouches for organizing and storing cables' },
  { title: 'Desktop Cable Management Tray', description: 'Tray for managing cables under your desk' },
  { title: 'Cable Tidy Box', description: 'Box for tidying and organizing cables' },
  { title: 'Wireless Network Extender', description: 'Device for extending the range of your wireless network' },
  { title: 'Smart Home Hub', description: 'Hub for integrating and controlling smart home devices' },
  { title: 'Computer Build Kit', description: 'Kit for assembling and customizing a computer' },
  { title: 'Gaming Keyboard with Macro Keys', description: 'Keyboard with programmable macro keys for gaming' },
  { title: 'Gaming Mouse Pad with Wrist Rest', description: 'Mouse pad with built-in wrist rest for comfort' },
  { title: 'Portable External Drive with Backup Software', description: 'External drive with backup software included' },
  { title: 'Adjustable Monitor Mount', description: 'Mount with adjustable arms for monitors' },
  { title: 'USB-C to Lightning Cable', description: 'Cable for connecting USB-C to Lightning devices' },
  { title: 'Bluetooth Audio Receiver', description: 'Receiver for adding Bluetooth audio to non-Bluetooth devices' },
  { title: 'Universal Laptop Charger', description: 'Charger compatible with various laptop brands' },
  { title: 'USB-C to HDMI Adapter with Power Delivery', description: 'Adapter for HDMI with USB-C power delivery support' },
  { title: 'Portable Power Supply', description: 'Portable power supply for powering devices on the go' },
  { title: 'Gaming Monitor with G-Sync', description: 'Monitor with G-Sync technology for smooth gaming' },
  { title: 'USB-C to DisplayPort Cable', description: 'Cable for connecting USB-C devices to DisplayPort displays' },
  { title: 'External SSD with High-Speed Data Transfer', description: 'External SSD with fast data transfer rates' },
  { title: 'Multi-Port USB-C Hub with Card Reader', description: 'USB-C hub with card reader and multiple ports' },
  { title: 'Adjustable Laptop Desk', description: 'Desk with adjustable height for laptop use' },
  { title: 'Computer Power Supply with Modular Cables', description: 'Power supply with modular cables for easy management' },
  { title: 'USB-C to USB-A Charging Cable', description: 'Charging cable for connecting USB-C to USB-A ports' },
  { title: 'USB-C to USB-C Cable with Fast Charging', description: 'Cable for fast charging USB-C devices' },
  { title: 'External Hard Drive with Password Protection', description: 'External drive with password protection' },
  { title: 'Computer Case with Tempered Glass', description: 'Case with tempered glass panels for a sleek look' },
  { title: 'Adjustable Desk with Cable Management', description: 'Desk with built-in cable management features' },
  { title: 'Portable Battery Charger for Laptops', description: 'Charger for providing power to laptops on the go' },
  { title: 'Wireless Gaming Headset', description: 'Gaming headset with wireless connectivity and high-quality audio' },
  { title: 'High-Speed Network Adapter', description: 'Adapter for fast network connections' },
  { title: 'USB-C to USB-A Adapter with OTG Support', description: 'Adapter for connecting USB-A devices to USB-C with OTG support' },
  { title: 'Desktop Cable Management Panel', description: 'Panel for managing cables on your desktop' },
  { title: 'External SSD with Shockproof Design', description: 'External SSD with a rugged, shockproof design' },
  { title: 'Multi-Function USB-C Hub', description: 'USB-C hub with multiple functions including HDMI and Ethernet' },
  { title: 'Portable Wi-Fi Hotspot', description: 'Device for creating a portable Wi-Fi network' },
  { title: 'Bluetooth USB Dongle', description: 'Dongle for adding Bluetooth capability to your PC' },
  { title: 'High-Capacity External Battery Pack', description: 'External battery pack with high capacity for extended usage' },
  { title: 'Desk Organizer with USB Ports', description: 'Desk organizer with built-in USB ports for charging' },
  { title: 'USB-C to VGA Adapter', description: 'Adapter for connecting USB-C devices to VGA monitors' },
  { title: 'Smart Desk Lamp with USB Charging', description: 'Desk lamp with USB charging port' },
  { title: 'USB-C to Mini DisplayPort Adapter', description: 'Adapter for connecting USB-C to Mini DisplayPort' },
  { title: 'Gaming Chair with Recline Feature', description: 'Gaming chair with reclining function for comfort' },
  { title: 'USB-C to HDMI Adapter with 4K Support', description: 'Adapter for connecting USB-C to HDMI with 4K resolution support' },
  { title: 'Wireless Charging Pad with Fast Charging', description: 'Wireless pad with fast charging capability' },
  { title: 'Computer Cooling Kit with Fans', description: 'Cooling kit including fans for optimal performance' },
  { title: 'Desk Stand for Laptop with Cooling Fan', description: 'Stand with built-in cooling fan for laptops' },
  { title: 'External Hard Drive with Cloud Backup', description: 'External hard drive with integrated cloud backup' },
  { title: 'USB-C to MicroSD Card Reader', description: 'Card reader for MicroSD cards with USB-C connectivity' },
  { title: 'Cable Management Sleeve with Magnetic Closure', description: 'Sleeve with magnetic closure for secure cable management' },
  { title: 'Smart Home Controller', description: 'Controller for managing various smart home devices' },
  { title: 'High-Speed External SSD', description: 'External SSD with high-speed data transfer rates' },
  { title: 'Portable USB Hub with Ethernet', description: 'Portable hub with Ethernet port and USB connections' },
  { title: 'USB-C Docking Station with Multiple Ports', description: 'Docking station with multiple ports and USB-C connectivity' },
  { title: 'Gaming Chair with Adjustable Armrests', description: 'Gaming chair with adjustable armrests for comfort' },
  { title: 'External Power Bank with Wireless Charging', description: 'Power bank with wireless charging capability' },
  { title: 'High-Speed USB-C Charging Cable', description: 'USB-C cable for high-speed charging' },
  { title: 'Portable Multi-Device Charger', description: 'Charger for multiple devices on the go' },
  { title: 'Smart Home Security System', description: 'Comprehensive security system for home monitoring' },
  { title: 'Desk Organizer with Cable Management', description: 'Desk organizer with built-in cable management features' },
  { title: 'Portable Power Bank with Solar Charging', description: 'Power bank with solar charging capability for outdoor use' },
  { title: 'Smart Home Climate Control System', description: 'System for controlling climate in a smart home' },
  { title: 'High-Speed USB-C Hub with Power Delivery', description: 'USB-C hub with power delivery and high-speed data transfer' },
  { title: 'External Hard Drive with High-Speed Transfer', description: 'External hard drive with high-speed data transfer capabilities' },
  { title: 'Adjustable Laptop Cooling Stand', description: 'Cooling stand for laptops with adjustable height' },
  { title: 'Multi-Function USB-C Charging Hub', description: 'Hub with multiple functions for USB-C devices' },
  { title: 'USB-C to Thunderbolt Adapter', description: 'Adapter for connecting USB-C devices to Thunderbolt ports' },
  { title: 'Wireless Smart Plug with Energy Monitoring', description: 'Smart plug with energy monitoring features' },
  { title: 'Portable Power Bank with Quick Charge', description: 'Power bank with quick charge capability' },
  { title: 'Gaming Monitor with High Refresh Rate', description: 'Monitor with high refresh rate for smooth gaming' },
  { title: 'External SSD with Rugged Design', description: 'External SSD with durable, rugged design' },
  { title: 'High-Speed USB-C Cable with Power Delivery', description: 'USB-C cable for high-speed data transfer and power delivery' },
  { title: 'Portable External Hard Drive with Encryption', description: 'Portable hard drive with built-in encryption for security' },
  { title: 'USB-C to DisplayPort Adapter with 4K Support', description: 'Adapter for connecting USB-C to DisplayPort with 4K support' },
  { title: 'Smart Light Strip with Remote Control', description: 'Light strip with remote control for smart lighting' },
  { title: 'Wireless Charging Pad with Adjustable Stand', description: 'Charging pad with adjustable stand for convenience' },
  { title: 'High-Speed HDMI Cable with Ethernet', description: 'HDMI cable with high-speed data transfer and Ethernet support' },
  { title: 'USB-C to Mini HDMI Adapter', description: 'Adapter for connecting USB-C to Mini HDMI' },
  { title: 'Gaming Keyboard with Backlighting', description: 'Keyboard with customizable backlighting for gaming' },
  { title: 'High-Capacity External Battery Charger', description: 'External battery charger with high capacity for extended use' },
  { title: 'Portable USB Charging Hub', description: 'Portable hub for charging multiple USB devices' },
  { title: 'USB-C to Thunderbolt 3 Adapter', description: 'Adapter for connecting USB-C devices to Thunderbolt 3 ports' },
  { title: 'Smart Home Voice Assistant', description: 'Voice-controlled assistant for smart home management' },
  { title: 'External Hard Drive with Built-In Backup Software', description: 'External hard drive with backup software included' },
  { title: 'Multi-Device Charging Station with Wireless Charging', description: 'Charging station with multiple ports and wireless charging' },
  { title: 'USB-C to Mini DisplayPort Cable', description: 'Cable for connecting USB-C devices to Mini DisplayPort displays' },
  { title: 'Gaming Mouse with Customizable Buttons', description: 'Mouse with customizable buttons for gaming' },
  { title: 'High-Speed USB-C Hub with 4K Support', description: 'USB-C hub with support for 4K video output' },
  { title: 'Portable Power Supply with USB-C Output', description: 'Portable power supply with USB-C output' },
  { title: 'Wireless Network Adapter with 5G Support', description: 'Network adapter with support for 5G wireless networks' },
  { title: 'USB-C Docking Station with 4K HDMI', description: 'Docking station with 4K HDMI output and USB-C connectivity' },
  { title: 'Portable External SSD with Fast Read/Write Speeds', description: 'External SSD with high read/write speeds for quick data access' },
  { title: 'Smart Home Hub with Voice Control', description: 'Hub for controlling smart home devices with voice commands' },
  { title: 'High-Speed USB-C Charging Hub', description: 'Charging hub with high-speed USB-C ports' },
  { title: 'External Hard Drive with High Capacity and Speed', description: 'External hard drive with high capacity and speed' },
  { title: 'Multi-Port USB-C Charger with Quick Charge', description: 'USB-C charger with multiple ports and quick charge support' },
  { title: 'Portable External Battery with Fast Charging', description: 'External battery with fast charging capability' },
  { title: 'Adjustable Desk with Built-In Charging Ports', description: 'Desk with built-in charging ports and cable management' },
  { title: 'Portable USB Hub with Multiple Ports', description: 'Portable USB hub with multiple ports for connectivity' },
  { title: 'USB-C to USB-C Cable with Power Delivery', description: 'Cable for USB-C to USB-C devices with power delivery' },
  { title: 'High-Speed External SSD with Encryption', description: 'External SSD with encryption for data security' },
  { title: 'Portable External Drive with Fast Transfer Rates', description: 'External drive with high-speed data transfer rates' },
  { title: 'Adjustable Desk with Monitor Mount', description: 'Desk with adjustable height and monitor mount' },
  { title: 'USB-C to HDMI Adapter with 4K Resolution', description: 'Adapter for USB-C to HDMI with 4K resolution support' },
  { title: 'Smart Home Security Camera with Night Vision', description: 'Security camera with night vision capabilities' },
  { title: 'High-Speed USB-C to USB-A Cable', description: 'USB-C to USB-A cable with high-speed data transfer' },
  { title: 'Portable External SSD with Password Protection', description: 'External SSD with password protection for data security' },
  { title: 'USB-C to HDMI Adapter with 8K Support', description: 'Adapter for connecting USB-C to HDMI with 8K resolution support' },
  { title: 'Smart Home Thermostat with Energy Monitoring', description: 'Smart thermostat with energy monitoring features' },
  { title: 'Adjustable Monitor Stand with Cable Management', description: 'Monitor stand with adjustable height and cable management' },
  { title: 'Portable Power Bank with High-Speed Charging', description: 'Portable power bank with high-speed charging capability' },
  { title: 'High-Speed USB-C Hub with Power Delivery and Ethernet', description: 'USB-C hub with power delivery and Ethernet support' },
  { title: 'External SSD with High-Speed Data Transfer', description: 'External SSD with fast data transfer rates' },
  { title: 'Smart Home Hub with Multiple Protocols', description: 'Smart home hub with support for multiple communication protocols' },
  { title: 'Adjustable Laptop Stand with Cooling Fan', description: 'Laptop stand with adjustable height and built-in cooling fan' },
  { title: 'High-Capacity USB-C Power Bank', description: 'USB-C power bank with high capacity for extended usage' },
  { title: 'Portable External Drive with High-Speed Data Transfer', description: 'External drive with high-speed data transfer rates' },
  { title: 'USB-C to DisplayPort Adapter with 4K Support', description: 'Adapter for connecting USB-C to DisplayPort with 4K resolution support' },
  { title: 'Smart Home Security System with Motion Detection', description: 'Security system with motion detection capabilities' },
  { title: 'Portable Power Bank with Built-In Cables', description: 'Power bank with built-in cables for convenience' },
  { title: 'High-Speed USB-C Charging Hub with Multiple Ports', description: 'USB-C charging hub with multiple ports and high-speed charging' },
  { title: 'Adjustable Desk with Wireless Charging', description: 'Desk with built-in wireless charging pad' },
  { title: 'Portable External SSD with Shockproof Design', description: 'External SSD with shockproof design for durability' },
  { title: 'Smart Home Controller with Voice Assistance', description: 'Home controller with voice assistance for smart devices' },
  { title: 'USB-C to Mini DisplayPort Adapter with 4K Support', description: 'Adapter for connecting USB-C to Mini DisplayPort with 4K support' },
  { title: 'High-Speed External Hard Drive with Encryption', description: 'External hard drive with high-speed data transfer and encryption' },
  { title: 'Adjustable Monitor Mount with Cable Management', description: 'Monitor mount with adjustable height and cable management' },
  { title: 'Smart Thermostat with Remote Control', description: 'Thermostat with remote control features for smart climate management' },
  { title: 'Portable External Hard Drive with Built-In Encryption', description: 'External hard drive with built-in encryption for data security' },
  { title: 'USB-C to Thunderbolt 4 Adapter', description: 'Adapter for connecting USB-C devices to Thunderbolt 4 ports' },
  { title: 'High-Speed USB-C Hub with 8K Support', description: 'USB-C hub with support for 8K video output' },
  { title: 'Adjustable Laptop Desk with Built-In Charging Ports', description: 'Laptop desk with built-in charging ports and cable management' }
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
      product.package_length = Faker::Number.between(from: 10, to: 50)
      product.package_width = Faker::Number.between(from: 10, to: 50)
      product.package_height = Faker::Number.between(from: 10, to: 50)
      product.package_weight = Faker::Number.decimal(l_digits: 1, r_digits: 2)
      product.media = [Faker::LoremFlickr.image, Faker::LoremFlickr.image]
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
  status = ['Processing', 'Dispatched', 'On-Transit', 'Delivered'].sample
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

