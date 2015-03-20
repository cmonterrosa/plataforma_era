class CreatePreparacions < ActiveRecord::Migration
  def self.up
    create_table :preparacions do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 5
    end

    Preparacion.create(:descripcion => "UTILIZAR AGUA HERVIDA O PURIFICADA Y CONSERVARLA EN RECIPIENTES LIMPIOS Y TAPADOS.", :clave => "PR01")
    Preparacion.create(:descripcion => "CONSUMIR LECHE SOMETIDA A ALGÚN TRATAMIENTO TÉRMICO (PASTEURIZADA, ULTRAPASTEURIZADA, HERVIDA, EVAPORADA, EN POLVO, ETC.). LA LECHE BRONCA DEBE HERVIRSE SIN EXCEPCIÓN.", :clave => "PR02")
    Preparacion.create(:descripcion => "COCER O FREIR BIEN LOS PESCADOS Y MARISCOS.", :clave => "PR03")
    Preparacion.create(:descripcion => "CONSUMIR LA CARNE DE RES O DE PUERCO BIEN COCIDA.", :clave => "PR04")

    add_index :preparacions, :clave, :name => "preparacions_clave"
  end

  def self.down
    drop_table :preparacions
  end
end
