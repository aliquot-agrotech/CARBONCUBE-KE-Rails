class CategoriesVendor < ApplicationRecord
  self.table_name = 'categories_vendors' # Explicitly set the table name
  belongs_to :vendor
  belongs_to :category
end
