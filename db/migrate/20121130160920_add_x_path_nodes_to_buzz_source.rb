class AddXPathNodesToBuzzSource < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :x_path_nodes, :string
  end
end
