class CreateEnergiaElectricas < ActiveRecord::Migration
  def self.up
    create_table :energia_electricas do |t|
      t.string :descripcion, :limit => 50
      t.string :clave, :limit => 5
    end

    EnergiaElectrica.create(:descripcion => "NO CUENTA CON MEDIDOR", :clave => "NCCM")
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON ENERGÍA ELÉCTRICA", :clave => "NCEN")
    EnergiaElectrica.create(:descripcion => ">> SELECCIONE UNA OPCIÓN", :clave => "SUOP")
    
  end

  def self.down
    drop_table :energia_electricas
  end
end
