class CreateBitacoras < ActiveRecord::Migration
  def self.up
    create_table :bitacoras do |t|
      t.integer :user_id
      t.integer :estatu_id
      t.timestamps
    end

  ### Indices para acceso más ágil ###
  add_index :bitacoras, :user_id, :name => "usuario"
  add_index :bitacoras, :estatu_id, :name => "estatus"

 end

  def self.down
    drop_table :bitacoras
  end
end
