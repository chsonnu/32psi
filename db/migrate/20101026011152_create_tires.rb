class CreateTires < ActiveRecord::Migration
  def self.up
    create_table :tires do |t|
      t.integer :width
      t.integer :sidewall
      t.integer :diameter
      t.integer :condition
      t.integer :user_id

      t.timestamps
    end
    
    add_index :tires, :user_id
  end

  def self.down
    drop_table :tires
  end
end
