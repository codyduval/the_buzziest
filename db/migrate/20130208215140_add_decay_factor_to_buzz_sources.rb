class AddDecayFactorToBuzzSources < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :decay_factor, :decimal, :default => 0.906
  end
end
