class CreateEnfermedads < ActiveRecord::Migration
  def self.up
    create_table :enfermedads do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Enfermedad.create(:descripcion => "PARASITARIAS", :clave => "PARA")
    Enfermedad.create(:descripcion => "GASTROINTESTINALES", :clave => "GAST")
    Enfermedad.create(:descripcion => "TIFOIDEA", :clave => "TIFO")
    Enfermedad.create(:descripcion => "SALMONELLA", :clave => "SALM")
    Enfermedad.create(:descripcion => "DIARREICA", :clave => "DIAR")
    Enfermedad.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :enfermedads, :clave, :name => "enfermedads_clave"
  end

  def self.down
    drop_table :enfermedads
  end
end
