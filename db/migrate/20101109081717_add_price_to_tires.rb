class AddPriceToTires < ActiveRecord::Migration
  def self.up
    add_column :tires, :price, :integer
  end

  def self.down
    remove_column :tires, :price
  end
end
