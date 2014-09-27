class CreateCatalogoInstitucions < ActiveRecord::Migration
  def self.up
    create_table :catalogo_institucions do |t|
      t.string :clave, :unique => true
      t.string :descripcion
      t.string :domicilio

#      t.timestamps
    end
    add_column :users, :catalogo_institucion_id, :integer
  end

  def self.down
    drop_table :catalogo_institucions
    remove_column :users, :catalogo_institucion_id
  end
end
