class CreateBuzzSourceTypes < ActiveRecord::Migration
  def change
    create_table :buzz_source_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
