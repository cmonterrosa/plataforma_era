class CreateAcciones < ActiveRecord::Migration
  def self.up
    create_table :acciones do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 5
    end

    Accione.create(:descripcion => "TUTORÍA.", :clave => "AC00")
    Accione.create(:descripcion => "PROYECTO DE MEJORA CONTINUA (PMC).", :clave => "AC01")
    Accione.create(:descripcion => "USO Y MANEJO DE LA CARTILLA NACIONAL DE VACUNACIÓN.", :clave => "AC032")
    Accione.create(:descripcion => "ACTIVIDADES ARTÍSTICAS Y DEPORTIVAS.", :clave => "AC03")
    Accione.create(:descripcion => "PREVENCIÓN DE RIESGO.", :clave => "AC04")
    Accione.create(:descripcion => "MEJORAMIENTOS DE ESPACIOS, AMBIENTE NATURAL E INFRAESTRUCTURA.", :clave => "AC05")
    Accione.create(:descripcion => "NINGUNA.", :clave => "NING")
   
    add_index :acciones, :clave, :name => "acciones_clave"
  end

  def self.down
    drop_table :acciones
  end
end
