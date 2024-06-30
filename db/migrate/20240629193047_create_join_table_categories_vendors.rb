class CreateJoinTableCategoriesVendors < ActiveRecord::Migration[7.1]
  def change
    create_join_table :categories, :vendors do |t|
      t.index [:category_id, :vendor_id]
      t.index [:vendor_id, :category_id]
    end
  end
end
