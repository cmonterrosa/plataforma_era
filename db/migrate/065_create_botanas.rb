class CreateBotanas < ActiveRecord::Migration
  def self.up
    create_table :botanas do |t|
      t.string :descripcion, :limit => 250
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Botana.create(:descripcion => "PALOMITAS DE MAÍZ SIN MANTEQUILLA Y CON POCA SAL.", :clave => "BS01", :tipo => "SALUDABLE")
    Botana.create(:descripcion => "OLEAGINOSAS SIN SAL: CACAHUATES CON CÁSCARA, PISTACHES, SEMILLAS DE GIRASOL, ALMENDRAS.", :clave => "BS02", :tipo => "SALUDABLE")
    Botana.create(:descripcion => "LEGUMINOSAS SECAS: HABAS SECAS, GARBANZOS SECOS (SIN SAL).", :clave => "BS03", :tipo => "SALUDABLE")
    Botana.create(:descripcion => "CACAHUATES U OTRAS OLEAGINOSAS EN PREPARACIONES CON HARINA, ACEITE O SAL
                                   (P. EJ. CACAHUATES JAPONESES, NUECES U OTRA OLEAGINOSA GARAPIÑADA, CACAHUATES FRITOS).", :clave => "BN04", :tipo => "NO SALUDABLE")
    Botana.create(:descripcion => "FRITURAS TANTO DE PREPARACIÓN CASERA COMO EMPAQUETADAS (P. EJ. PAPAS SALADAS,
                                   PAPAS ADOBADAS, NACHOS, DE HARINA DE MAÍZ, CON SABOR A QUESO, CHURRITOS CON SAL Y LIMÓN,
                                   CHICHARRONES, ETC.).", :clave => "BN05", :tipo => "NO SALUDABLE")
    Botana.create(:descripcion => "EMBUTIDOS (P. EJ. SALCHICHAS FRITAS O SIN FREÍR).", :clave => "BN06", :tipo => "NO SALUDABLE")

    add_index :botanas, :clave, :name => "botanas_clave"
  end

  def self.down
    drop_table :botanas
  end
end
