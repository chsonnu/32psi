class ModifyColumnType2 < ActiveRecord::Migration
  def self.up
    change_column :tires, :condition, :integer
  end

  def self.down
  end
end
