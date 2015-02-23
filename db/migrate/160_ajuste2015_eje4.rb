class Ajuste2015Eje4 < ActiveRecord::Migration
  def self.up
    puts("=> Ajuste del Eje 4 del diagnostico, ciclo 2014-2015")
    # Pregunta 1
    Establecimiento.create(:clave => "CCCT", :nivel => "BASICA", :descripcion => "LA ESCUELA CUENTA CON CAFETERIA O TIENDA ESCOLAR" )
  
    # Pregunta 3
    remove_column :consumos, :conocen_lineamientos_grales
    add_column :consumos, :aplican_lineamientos_grales, :string, :limit => 2

    ## Pregunta 5 ###
    @bebida = Bebida.find_by_clave("RGEC")
    @bebida.update_attributes!(:descripcion => "REFRESCOS CON Y SIN GAS, CON EDULCORANTES CALÓRICOS Y NO CALÓRICOS." ) if @bebida
  end

  def self.down
    Establecimiento.find_by_clave("CCCT").destroy if Establecimiento.find_by_clave("CCCT")
    remove_column :consumos, :aplican_lineamientos_grales
    #add_column :consumos, :conocen_lineamientos_grales, :string, :limit => 2
  end
end
