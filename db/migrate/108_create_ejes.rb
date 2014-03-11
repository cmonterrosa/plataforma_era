class CreateEjes < ActiveRecord::Migration
  def self.up
    create_table :ejes do |t|
      t.string :objetivo_especifico, :limit => 300
      t.string :meta, :limit => 300
      t.integer :proyecto_id
      t.integer :catalogo_eje_id
      t.timestamps
    end

     add_index :ejes, :proyecto_id, :name => "eje_proyecto_id"
     add_index :ejes, :catalogo_eje_id, :name => "eje_catalogo_eje_id"
  end

  def self.down
    drop_table :ejes
  end
end
