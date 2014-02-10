class CreateAlimentos < ActiveRecord::Migration
  def self.up
    create_table :alimentos do |t|
      t.string :descripcion, :limit => 400
      t.string :clave, :limit => 15
      t.string :tipo, :limit => 15
    end

    Alimento.create(:descripcion => "SÁNDWICH O TORTA DE: QUESO BAJO EN GRASA CON FRIJOLES Y AGUACATE, O DE FRIJOLES, 
                                     O DE POLLO, O DE ATÚN, O DE HUEVO.", :clave => "AS01", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "TACOS SUAVES EN TORTILLA DE MAÍZ CON GUISADOS CON BAJO CONTENIDO DE GRASA: FRIJOL,
                                     POLLO CON VERDURAS, CALABACITAS GUISADAS, HUEVO CON NOPALES, EJOTE CON HUEVO,
                                     PAPA CON VERDURAS, HONGOS, NOPALES CON QUESO, BISTEC CON CEBOLLAS Y/O PAPAS,
                                     ALAMBRE DE BISTEC, RAJAS CON BISTEC, FAJITAS DE POLLO, PREPARACIONES A BASE DE SOYA,
                                     SIN EMBUTIDOS.", :clave => "AS02", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "TORTILLAS DE MAÍZ TOSTADAS (HORNEADAS, NO FRITAS) DE: FRIJOL Y QUESO, TINGA DE POLLO,
                                     ENSALADA DE POLLO, ENSALADA DE ATÚN, PREPARACIONES A BASE DE SOYA.", :clave => "AS03", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "QUESADILLAS CON TORTILLA DE MAÍZ DE QUESO PANELA O CON VERDURAS (HONGOS, FLOR DE CALABAZA,
                                     PAPA CON CEBOLLAS).", :clave => "AS04", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "SOPES.", :clave => "AS05", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "ENFRIJOLADAS.", :clave => "AS06", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "SOPA DE FRIJOL COCIDO (CALDO DE FRIJOL).", :clave => "AS07", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "CHILAQUILES.", :clave => "AS08", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "ENCHILADAS VERDES.", :clave => "AS09", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "BURRITOS DE: FRIJOLES, FRIJOLES CON POLLO (NOTA: DEBE SER TORTILLA DE HARINA INTEGRAL).", :clave => "AS10", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "ELOTE CON LIMÓN Y CHILE (SIN O CON POCA MAYONESA).", :clave => "AS11", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "ESQUITES CON LIMÓN Y CHILE (SIN O CON POCA MAYONESA).", :clave => "AS12", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "ENSALADAS: DE LECHUGA CON JITOMATE Y PEPINO, LECHUGA CON FRUTA,
                                     CUCHARADA DE ADEREZO POR PORCIÓN.", :clave => "AS13", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "COCKTEL Y/O FRUTAS DE TEMPORADA   (MENOS DE UNA PIZCA DE SAL,
                                     CON MIEL Y/O GRANOLA).", :clave => "AS14", :tipo => "SALUDABLE")
    Alimento.create(:descripcion => "TAMALES QUE NO UTILICEN MANTECA DE ORIGEN ANIMAL EN LA PREPARACIÓN DE LOS MISMOS (POR EJEMPLO:
                                     TAMALES DE VERDURA, ELOTE, FRIJOL).", :clave => "AS15", :tipo => "SALUDABLE")

    Alimento.create(:descripcion => "ENSALADAS DE FRUTAS Y VERDURAS CON CANTIDADES ELEVADAS DE SAL
                                     (MÁS DE UNA PIZCA DE SAL Y/O CHILE).", :clave => "AN16", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "TOSTADAS PREPARADAS CON GUISADOS CON ALTO CONTENIDO DE GRASA Y SERVIDAS CON CANTIDADES
                                     ELEVADAS DE CREMA Y QUESO.", :clave => "AN17", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "PREPARACIONES FRITAS: ENCHILADAS FRITAS VERDES, ENTOMATADAS FRITAS,
                                     CHILAQUILES FRITOS, SINCRONIZADAS FRITAS.", :clave => "AN18", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "TACOS, FLAUTAS, QUESADILLAS Y OTRAS PREPARACIONES CON MAÍZ FRITAS: DE CECINA,
                                     DORADOS CON PAPA, DE CHORIZO O CERDO, QUESO CON JAMÓN, SALCHICHA CON JAMÓN,
                                     BARBACOA, AL PASTOR.", :clave => "AN19", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "GORDITAS: CARNE, CHORIZO, PAPA, FRIJOL.", :clave => "AN20", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "SÁNDWICH O TORTA CON GUISADOS FRITOS O CON ALTO CONTENIDO DE GRASAS Y/O SAL: SALCHICHA, 
                                     JAMÓN, FRIJOLES, QUESO CON JAMÓN, SALCHICHA CON JAMÓN, MOLE ROJO, HUEVO, HUEVO CON JITOMATE, 
                                     HUEVO CON CHORIZO, FRIJOLES CON JAMÓN, BISTEC, AGUACATE, PASTEL DE POLLO, MILANESA, COCHINITA, 
                                     LONGANIZA, CHORIZO, CHICHARRÓN, QUESO AMARILLO, VÍSCERAS, PATAS DE POLLO O MOLLEJAS.",
                                     :clave => "AN21", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "GUISADOS QUE UTILICEN MANTECA DE ORIGEN ANIMAL EN LA PREPARACIÓN DE LOS MISMOS.", :clave => "AN22", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "VOLOVANES: ATÚN, MOLE, JAMÓN, CHORIZO, SALCHICHA, QUESO AMARILLO, QUESILLO.", :clave => "AN23", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "MOLLETES.", :clave => "AN24", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "TAMALES QUE UTILICEN MANTECA DE ORIGEN ANIMAL EN LA PREPARACIÓN DE LOS MISMOS
                                     (POR EJEMPLO: TAMALES DE MOLE, BOLA, CHICHARRÓN).", :clave => "AN25", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "SOPAS INSTANTÁNEAS.", :clave => "AN26", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "PIZZAS, HAMBURGUESAS, HOTDOG.", :clave => "AN27", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "NACHOS.", :clave => "AN28", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "PLÁTANOS FRITOS.", :clave => "AN29", :tipo => "NO SALUDABLE")
    Alimento.create(:descripcion => "HOT CAKES.", :clave => "AN30", :tipo => "NO SALUDABLE")

    add_index :alimentos, :clave, :name => "bebidas_clave"
  end

  def self.down
    drop_table :alimentos
#     remove_columns :proyectos, :programa_id
  end
end
