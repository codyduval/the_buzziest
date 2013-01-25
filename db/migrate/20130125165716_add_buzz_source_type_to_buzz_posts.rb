class AddBuzzSourceTypeToBuzzPosts < ActiveRecord::Migration
  def change
        add_column :buzz_sources, :buzz_source_type, :string
  end
end
