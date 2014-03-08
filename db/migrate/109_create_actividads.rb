class CreateActividads < ActiveRecord::Migration
  def self.up
    create_table :actividads do |t|
      t.string :clave, :limit => 10
      t.string :descripcion, :limit => 300
      t.integer :eje_id
      #t.integer :catalogo_actividad_id
      t.datetime :fecha_hora_revision
      t.timestamps
    end

    add_index :actividads, :eje_id, :name => "actividads_eje_id"
    add_index :actividads, :clave, :name => "actividads_clave"
    add_index :actividads, [:clave, :eje_id], :name => "actividads_eje_clave"
  end

  def self.down
    drop_table :actividads
  end
end
