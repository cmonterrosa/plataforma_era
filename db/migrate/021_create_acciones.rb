class CreateAcciones < ActiveRecord::Migration
  def self.up
    create_table :acciones do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    Accione.create(:descripcion => "ORIENTACIÓN Y ASESORÍA.", :clave => "AC00")
    Accione.create(:descripcion => "USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "AC01")
    Accione.create(:descripcion => "ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "AC02")
    Accione.create(:descripcion => "PREVENCIÓN DE RIESGO.", :clave => "AC03")
    Accione.create(:descripcion => "MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "AC04")
   
    add_index :acciones, :clave, :name => "acciones_clave"
  end

  def self.down
    drop_table :acciones
  end
end
