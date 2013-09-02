class CreateHuellas < ActiveRecord::Migration
  def self.up
    create_table :huellas do |t|
      
      t.timestamps
    end
  end

  def self.down
    drop_table :huellas
  end
end
