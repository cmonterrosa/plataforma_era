class CreateDcapacitadoras < ActiveRecord::Migration
  def self.up
    create_table :dcapacitadoras do |t|
      t.string :descripcion, :limit => 200
      t.string :clave, :limit => 10
    end

    Dcapacitadora.create(:descripcion => "SECRETARÍA DE EDUCACIÓN (CEFC).", :clave => "CEFC")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE SALUD.", :clave => "SDS")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE MEDIO AMBIENTE E HISTORIA NATURAL (SEMAHN).", :clave => "SEMAHN")
    Dcapacitadora.create(:descripcion => "SECRETARÍA DE MEDIO AMBIENTE  Y RECURSOS NATURALES (SEMARNAT).", :clave => "SEMARNAT")
    Dcapacitadora.create(:descripcion => "PROTECCIÓN CIVIL.", :clave => "PC")
    Dcapacitadora.create(:descripcion => "COMISIÓN NACIONAL FORESTAL (CONAFOR).", :clave => "CONAFOR")
    Dcapacitadora.create(:descripcion => "COMISIÓN NACIONAL DEL AGUA (CONAGUA).", :clave => "CONAGUA")
    Dcapacitadora.create(:descripcion => "OTRA DEPENDENCIA GUBERNAMNETAL O PRIVADA.", :clave => "OTRA")
  end

  def self.down
    drop_table :dcapacitadoras
  end
end
