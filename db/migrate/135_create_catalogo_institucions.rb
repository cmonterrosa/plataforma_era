class CreateCatalogoInstitucions < ActiveRecord::Migration
  def self.up
    create_table :catalogo_institucions do |t|
      t.string :clave
      t.string :descripcion
      t.string :domicilio

#      t.timestamps
    end
  end

  def self.down
    drop_table :catalogo_institucions
  end
end
