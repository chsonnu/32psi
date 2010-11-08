class ChangeTires < ActiveRecord::Migration
  def self.up
      change_column_default(:tires, :quantity, 1)
  end

  def self.down
  end
end
