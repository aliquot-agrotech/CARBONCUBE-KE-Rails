class CreateClickEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :click_events do |t|
      t.references :purchaser, foreign_key: true, null: true # Nullable for guests
      t.references :product, foreign_key: true, null: true # Nullable for clicks not tied to a product
      t.string :event_type, null: false
      t.jsonb :metadata, default: {} # Additional info (e.g., vendor ID)

      t.timestamps
    end
  end
end
