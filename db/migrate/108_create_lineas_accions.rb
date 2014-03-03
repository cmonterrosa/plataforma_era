class CreateLineasAccions < ActiveRecord::Migration
  def self.up
    create_table :lineas_accions do |t|
      t.string :clave
      t.string :descripcion

      t.timestamps
    end
  end

  def self.down
    drop_table :lineas_accions
  end
end
