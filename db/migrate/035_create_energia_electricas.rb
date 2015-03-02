class CreateEnergiaElectricas < ActiveRecord::Migration
  def self.up
    create_table :energia_electricas do |t|
      t.string :descripcion, :limit => 80
      t.string :clave, :limit => 5
    end

    EnergiaElectrica.create(:descripcion => "NO CUENTA CON MEDIDOR", :clave => "NCCM")
    EnergiaElectrica.create(:descripcion => "NO CUENTA CON ENERGÍA ELÉCTRICA", :clave => "NCEN")
    EnergiaElectrica.create(:descripcion => "LA SECRETARÍA DE EDUCACIÓN CUBRE EL COSTO DE LA ENERGÍA ANTE LA CFE", :clave => "SECC")
    EnergiaElectrica.create(:descripcion => "NO RECIBE APOYO DE LA SECRETARÍA DE EDUCACIÓN", :clave => "NING")
    
  end

  def self.down
    drop_table :energia_electricas
  end
end
