class CreateReposterias < ActiveRecord::Migration
  def self.up
    create_table :reposterias do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Reposteria.create(:descripcion => "GALLETAS PREPARADAS CON AVENA INTEGRAL.", :clave => "RS01", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BARRAS DE FRUTAS.", :clave => "RS02", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BARRA PREPARADA CON MULTIGRANO Y NUEZ.", :clave => "RS03", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BOTANA DE FRUTAS DESHIDRATADAS.", :clave => "RS04", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "CEREAL DE AVENA Y CEREAL DE TRIGO, MAÍZ Y ARROZ INTEGRAL.", :clave => "RS05", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BARRA DE AMARANTO, CON BAJO CONTENIDO DE AZÚCAR.", :clave => "RS06", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BARRA DE AMARANTO CON HOJUELAS DE TRIGO, ARROZ Y AGLOMERADOS DE AVENA,
                                       CON BAJO CONTENIDO DE AZÚCAR.", :clave => "RS07", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "BARRA DE HOJALDRE DE TRIGO Y RELLENO DE FRUTA NATURAL,
                                       CON BAJO CONTENIDO DE AZÚCAR", :clave => "RS08", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "CEREALES LISTOS PARA CONSUMIR: MULTIGRANO DE HOJUELAS DE ARROZ Y
                                       AMARANTO CON AGLOMERADOS DE AVENA.", :clave => "RS09", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "LINAZA Y SEMILLAS DE GIRASOL, CON BAJO CONTENIDO DE AZÚCAR.", :clave => "RS10", :tipo => "SALUDABLE")
    Reposteria.create(:descripcion => "PAN DULCE.", :clave => "RN11", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "PASTELES.", :clave => "RN12", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "GALLETAS DULCES Y PASTELILLOS (P. EJ. CON RELLENO SABOR CHOCOLATE O VAINILLA,
                                       CON CHISPAS DE CHOCOLATE, CON CUBIERTA  DULCE O GLASEADAS).", :clave => "RN13", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "CEREALES LISTOS PARA CONSUMIR CON ALTO CONTENIDO DE AZÚCAR Y/O SODIO
                                       (P. EJ. HOJUELAS DE MAÍZ, HOJUELAS DE MAÍZ CON AZÚCAR, ARROZ INFLADO CON AZÚCAR Y SABORIZANTES).", :clave => "RN14", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "FLANES Y GELATINAS CON ALTO CONTENIDO DE AZÚCAR.", :clave => "RN15", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "YOGURT SÓLIDO CON ALTO CONTENIDO DE AZÚCAR.", :clave => "RN16", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "BEBIDA LÁCTEA FERMENTADA ADICIONADA CON AZÚCAR.", :clave => "RN17", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "FRUTAS EN ALMÍBAR.", :clave => "RN18", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "HELADOS.", :clave => "RN19", :tipo => "NO SALUDABLE")
    Reposteria.create(:descripcion => "DULCES (EJEMPLO: GOLOSINAS DULCES, ENCHILADAS, SALADAS O ACIDULADAS).", :clave => "RN20", :tipo => "NO SALUDABLE")
    
    add_index :reposterias, :clave, :name => "reposterias_clave"
  end

  def self.down
    drop_table :reposterias
  end
end
