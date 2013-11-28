class CreateActividads < ActiveRecord::Migration
  def self.up
    create_table :actividads do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Actividad.create(:descripcion => "CAMPAÑAS DE REFORESTACIÓN", :clave => "CAMR")
    Actividad.create(:descripcion => "ELABORACIÓN DE COMPOSTAS", :clave => "ELAC")
    Actividad.create(:descripcion => "CAMPAÑAS DE LIMPIOEZA EN ÁREAS VERDES", :clave => "CAML")
    Actividad.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :actividads, :clave, :name => "actividads_clave"
  end

  def self.down
  #  drop_table :actividads
  end
end
