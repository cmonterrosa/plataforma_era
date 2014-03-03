class CreateIndicadores < ActiveRecord::Migration
  def self.up
    create_table :indicadores do |t|
      t.string :clave
      t.string :descripcion

      t.timestamps
    end
  end

  def self.down
    drop_table :indicadores
  end
end
