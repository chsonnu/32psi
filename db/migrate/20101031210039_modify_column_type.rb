class ModifyColumnType < ActiveRecord::Migration
  def self.up
    change_column :tires, :condition, :string
  end

  def self.down
  end
end
