class RemoveTypeFromBuzzSourceType < ActiveRecord::Migration
  def change
        add_column :buzz_source_types, :source_type, :string
        remove_column :buzz_source_types, :type
  end
end
