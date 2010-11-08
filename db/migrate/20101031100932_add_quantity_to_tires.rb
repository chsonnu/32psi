class AddQuantityToTires < ActiveRecord::Migration
  def self.up
    add_column :tires, :quantity, :integer
  end

  def self.down
    remove_column :tires, :quantity
  end
end
