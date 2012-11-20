class AddSourceTypeToBuzzSources < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :source_type, :string
  end
end
