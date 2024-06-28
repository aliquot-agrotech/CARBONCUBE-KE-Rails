class Product < ApplicationRecord
  belongs_to :vendor
  belongs_to :category
end
