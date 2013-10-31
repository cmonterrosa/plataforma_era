class CreateCmambientes < ActiveRecord::Migration
  def self.up
    create_table :cmambientes do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 15
    end

    Cmambiente.create(:descripcion => "PERDIDA DE BIODIVERSIDAD", :clave => "PBIODIVERSIDAD")
    Cmambiente.create(:descripcion => "CONTAMINACIÓN", :clave => "CONTAMINACION")
    Cmambiente.create(:descripcion => "DEFORESTACIÓN", :clave => "DEFORESTACION")
    Cmambiente.create(:descripcion => "CAMBIO CLIMÁTICO", :clave => "CCLIMATICO")
    Cmambiente.create(:descripcion => "OTROS", :clave => "OTR")

    add_index :cmambientes, :clave, :name => "capacitan_cmambientes_clave"
  end

  def self.down
    drop_table :cmambientes
  end
end
