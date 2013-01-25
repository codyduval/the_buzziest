class DropBuzzSourceTypesTable < ActiveRecord::Migration
  def change
    drop_table :buzz_source_types
  end
end
