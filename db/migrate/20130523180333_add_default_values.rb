class AddDefaultValues < ActiveRecord::Migration
  def up
    change_column :buzz_posts, :post_weight, :decimal, :default => 1.0    
    change_column :buzz_sources, :buzz_weight, :decimal, :default => 1.0    
    remove_column :buzz_sources, :source_id_tag
    remove_column :buzz_sources, :city_id
    remove_column :buzz_sources, :buzz_source_type_id
    remove_column :restaurants, :city_id
    change_column :restaurants, :skip_scan, :boolean, :default => false
    change_column :restaurants, :exact_match, :boolean, :default => false

  end

  def down
    change_column :buzz_posts, :post_weight, :decimal
    change_column :buzz_sources, :buzz_weight, :decimal
    add_column :buzz_sources, :source_id_tag, :string 
    add_column :buzz_sources, :city_id, :integer
    add_column :buzz_sources, :buzz_source_type_id, :integer
    add_column :restaurants, :city_id, :integer
    change_column :restaurants, :skip_scan, :boolean
    change_column :restaurants, :exact_match, :boolean
  end

end
