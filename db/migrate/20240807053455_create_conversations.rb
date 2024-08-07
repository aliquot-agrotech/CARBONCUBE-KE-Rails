class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :admin, foreign_key: { to_table: :admins }
      t.references :purchaser, foreign_key: { to_table: :purchasers }
      t.references :vendor, foreign_key: { to_table: :vendors }
      t.timestamps
    end
  end
end
