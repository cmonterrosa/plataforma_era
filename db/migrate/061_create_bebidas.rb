class CreateBebidas < ActiveRecord::Migration
  def self.up
    create_table :bebidas do |t|
      t.string :descripcion, :limit => 150
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Bebida.create(:descripcion => "AGUA NATURAL POTABLE (APTA PARA CONSUMO HUMANO).", :clave => "ANPO", :tipo => "SALUDABLE")
    Bebida.create(:descripcion => "LECHE DESCREMADA SIN AZÚCARES, NI EDULCORANTES O SABORIZANTES.", :clave => "LDAE", :tipo => "SALUDABLE")
    Bebida.create(:descripcion => "JUGOS DE FRUTAS: 100% NATURAL SIN AZÚCARES, NI EDULCORANTES O SABORIZANTES.", :clave => "JFSA", :tipo => "SALUDABLE")
    Bebida.create(:descripcion => "REFRESCOS CON Y SIN GAS, CON EDULCORANTES CALÓRICOS Y NO CALÓRICOS.", :clave => "RGEC", :tipo => "NO SALUDABLE")
    Bebida.create(:descripcion => "JUGOS DE FRUTAS CON AZÚCARES AÑADIDOS.", :clave => "JFCA", :tipo => "NO SALUDABLE")
    Bebida.create(:descripcion => "BEBIDAS LÁCTEAS ADICIONADAS CON AZÚCAR.", :clave => "BLAZ", :tipo => "NO SALUDABLE")

    add_index :bebidas, :clave, :name => "bebidas_clave"
  end

  def self.down
    drop_table :bebidas
  end
end
