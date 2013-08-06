class AddFilterWordToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :filter_words, :text
  end
end
