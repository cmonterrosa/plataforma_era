class CreateCactividads < ActiveRecord::Migration
  def self.up
    create_table :cactividads do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 15
    end

    Cactividad.create(:descripcion => "REFORESTACIÓN ", :clave => "REFORESTACION")
    Cactividad.create(:descripcion => "ESTILO DE VIDA SALUDABLE", :clave => "VSALUDABLE")
    Cactividad.create(:descripcion => "CAMPAÑAS DE SALUD E HIGIENE", :clave => "CSALUD")
    Cactividad.create(:descripcion => "USO CONSCIENTE DE LOS RECURSOS NATURALES", :clave => "RNATURALES")
    Cactividad.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :cactividads, :clave, :name => "cactividads_clave"
  end

  def self.down
   # drop_table :cactividads
  end
end
