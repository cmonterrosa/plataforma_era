class ChangeComunitariaToExtraescolar < ActiveRecord::Migration
  def self.up
    #### Ajustamos  estatus al más alto que tienen en la bitacora #####
    @escuelas = Escuela.find(:all, :conditions => ["nivel_descripcion = 'COMUNITARIA' "])

    if @escuelas.size.to_i > 0
      puts "Total de Escuelas Comunitarias: #{@escuelas.size}"
      contador=0
      @escuelas.each do |e|
        e.update_attributes!(:nivel_descripcion => 'EXTRAESCOLAR' )
        contador+=1
      end
      puts("Total de escuelas actualizadas: #{contador}")
    end
    
    @nivel = Nivel.find_by_descripcion("COMUNITARIA")

    if @nivel
      @nivel.update_attributes!(:descripcion => 'EXTRAESCOLAR')
    end

  end

  def self.down
  end
end
