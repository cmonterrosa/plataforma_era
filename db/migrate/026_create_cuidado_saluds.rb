class CreateCuidadoSaluds < ActiveRecord::Migration
  def self.up
    create_table :cuidado_saluds do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    CuidadoSalud.create(:descripcion => "TALLERES", :clave => "TALL")
    CuidadoSalud.create(:descripcion => "CAPACITACIONES", :clave => "CAPA")
    CuidadoSalud.create(:descripcion => "PLATICAS", :clave => "PLAT")
    CuidadoSalud.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :cuidado_saluds, :clave, :name => "cuidado_saluds_clave"
  end

  def self.down
    drop_table :cuidado_saluds
  end
end
