class AddBuzzSourceTypeToBuzzSource < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :buzz_source_type_id, :integer
  end
end
