class AddPgSearchIndexesToProducts < ActiveRecord::Migration[7.1]
  def change
    enable_extension :pg_trgm

    add_index :products, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :products, :description, using: :gin, opclass: :gin_trgm_ops
  end
end
