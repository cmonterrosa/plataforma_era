class Ajuste2015Eje4 < ActiveRecord::Migration
  def self.up
    puts("=> Ajuste del Eje 4 del diagnostico, ciclo 2014-2015")
    # Pregunta 1
    Establecimiento.create(:clave => "CCCT", :nivel => "BASICA", :descripcion => "LA ESCUELA CUENTA CON CAFETERIA O TIENDA ESCOLAR" )
 
    ## Pregunta 5 ###
    @bebida = Bebida.find_by_clave("RGEC")
    @bebida.update_attributes!(:descripcion => "REFRESCOS CON Y SIN GAS, CON EDULCORANTES CALÓRICOS Y NO CALÓRICOS." ) if @bebida
  end

  def self.down
    Establecimiento.find_by_clave("CCCT").destroy if Establecimiento.find_by_clave("CCCT")
  end
end
