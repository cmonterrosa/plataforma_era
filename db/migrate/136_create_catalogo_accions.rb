class CreateCatalogoAccions < ActiveRecord::Migration
  def self.up
    create_table :catalogo_accions do |t|
      t.string :clave
      t.string :descripcion
      t.integer :institucion_id

#      t.timestamps
    end
  end

  def self.down
    drop_table :catalogo_accions
  end
end
