class UpdateDescripcionNivelesEscuelas < ActiveRecord::Migration
  def self.up
    contador_general=1
    total_escuelas = Escuela.count(:id)
    puts("=> Total de escuelas en bd: #{total_escuelas}")
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/clasificacion_niveles2014.csv").each_line { |line|
      descripcion, prefijo = line.split(",")

      begin
        @escuelas = Escuela.find(:all, :conditions => ["clave like ?", "#{prefijo.strip}%"])
        contador_local=0
        unless @escuelas.empty?
          @escuelas.each{|e|
            e.update_attributes!(:nivel_descripcion => descripcion.strip) if descripcion
            contador_local+=1
            contador_general+=1
          }
        puts ("=> Total #{descripcion}: #{contador_local}")
        else
          puts("=> Prefijo: #{prefijo} no encontro resultados")
        end


      rescue => e
        puts e
      end

     }
     puts("=> Total de escuelas procesadas: #{contador_general}")
  end

  def self.down
   puts("=> No tiene accionr reversiva")
  end
end
