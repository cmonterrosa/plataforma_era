class CreateTambientals < ActiveRecord::Migration
  def self.up
    create_table :tambientals do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 15
    end

    Tambiental.create(:descripcion => "CONCIENCIA AMBIENTAL Y SUSTENTABILIDAD ", :clave => "CAMBIENTAL")
    Tambiental.create(:descripcion => "LA EDUCACIÓN AMBINETAL EN LA PRÁCTICA DOCENTE", :clave => "EAMBIENTAL")
    Tambiental.create(:descripcion => "QUE CAMBIA CON EL CAMBIO CLIMÁTICO", :clave => "CCLIMATICO")
    Tambiental.create(:descripcion => "EDUCACIÓN AMBIENTAL", :clave => "EAMBIENTAL")
    Tambiental.create(:descripcion => "PRÁCTICAS EDUCATIVAS PARA EL DESARROLLO SUSTENTABLE", :clave => "PEDUCATIVA")
    Tambiental.create(:descripcion => "EDUCACIÓN, INTERCULTURALIDAD Y AMBIENTE", :clave => "EDUINTERAMB")
    Tambiental.create(:descripcion => "CAMBIO CLIMÁTICO, CIENCIA, EVIDENCIA Y ACCIÓN", :clave => "CAMBIOCCEA")
    Tambiental.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :tambientals, :clave, :name => "tambientals_clave"
  end

  def self.down
    drop_table :tambientals
  end
end
