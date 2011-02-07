class AddDescriptionToTires < ActiveRecord::Migration
  def self.up
    add_column :tires, :description, :string
  end

  def self.down
    remove_column :tires, :description
  end
end
