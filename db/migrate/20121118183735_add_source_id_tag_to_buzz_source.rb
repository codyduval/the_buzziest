class AddSourceIdTagToBuzzSource < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :source_id_tag, :string
  end
end
