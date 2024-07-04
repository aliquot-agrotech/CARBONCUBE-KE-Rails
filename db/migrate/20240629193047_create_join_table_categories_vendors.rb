class CreateJoinTableCategoriesVendors < ActiveRecord::Migration[7.1]
  def change
    create_join_table :vendors, :categories do |t|
      t.index [:vendor_id, :category_id]
      t.index [:category_id, :vendor_id]
      
    end
  end
end
