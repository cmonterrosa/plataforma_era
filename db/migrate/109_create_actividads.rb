class CreateActividads < ActiveRecord::Migration
  def self.up
    create_table :actividads do |t|
      t.string :descripcion, :limit => 300
      t.integer :eje_id
      t.integer :catalogo_actividad_id
      t.timestamps
    end

    

    add_index :actividads, :eje_id, :name => "actividads_eje_id"
  end

  def self.down
    drop_table :actividads
  end
end
