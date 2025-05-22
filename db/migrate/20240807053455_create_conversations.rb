class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :admin, foreign_key: { to_table: :admins }, null: true
      t.references :purchaser, foreign_key: { to_table: :purchasers }, null: true
      t.references :vendor, foreign_key: { to_table: :vendors }, null: true
      t.references :ad, foreign_key: true, null: true  # Or :ad if you use that model name

      t.timestamps
    end

    # Optional: Enforce uniqueness of a conversation between purchaser, vendor, and ad
    add_index :conversations, [:purchaser_id, :vendor_id, :ad_id], unique: true, name: "index_conversations_on_purchaser_vendor_product"
  end
end
