class OrderVendor < ApplicationRecord
    belongs_to :order
    belongs_to :vendor
end