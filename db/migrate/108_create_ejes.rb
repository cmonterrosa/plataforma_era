class CreateEjes < ActiveRecord::Migration
  def self.up
    create_table :ejes do |t|
      t.string :objetivo_especifico, :limit => 300
      t.string :meta, :limit => 300
      t.string :actividad1, :limit => 300
      t.string :actividad2, :limit => 300
      t.string :actividad3, :limit => 300
      t.string :actividad4, :limit => 300
      t.integer :proyecto_id
      t.integer :catalogo_eje_id
      t.integer :lineas_accion_id
      t.integer :indicadore_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ejes
  end
end
