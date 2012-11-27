class RemoveSourceTypeFromBuzzSources < ActiveRecord::Migration
  def change
        remove_column :buzz_sources, :source_type
  end
end
