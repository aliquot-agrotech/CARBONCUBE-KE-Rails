class BuyForMeOrderVendor < ApplicationRecord
  belongs_to :buy_for_me_order
  belongs_to :vendor
end