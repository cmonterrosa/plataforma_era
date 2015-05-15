class ReorganizacionPrefijosModalidades < ActiveRecord::Migration

  def self.up
    add_column :escuelas, :modalidad_alternativa, :string, :limit => 30
    Nivel.create(:clave => 8, :descripcion => "INICIAL") unless Nivel.find_by_descripcion("INICIAL")
    Nivel.create(:clave => 9, :descripcion => "MISIONES CULTURALES") unless Nivel.find_by_descripcion("MISIONES CULTURALES")
    Nivel.create(:clave => 10, :descripcion => "CAPACITACION PARA EL TRABAJO") unless Nivel.find_by_descripcion("CAPACITACION PARA EL TRABAJO")
    Nivel.create(:clave => 11, :descripcion => "PROFESIONAL MEDIO") unless Nivel.find_by_descripcion("PROFESIONAL MEDIO")
    Nivel.create(:clave => 11, :descripcion => "NORMAL LICENCIATURA") unless Nivel.find_by_descripcion("NORMAL LICENCIATURA")
    Nivel.create(:clave => 12, :descripcion => "UNIVERSITARIO Y TECNOLOGICO") unless Nivel.find_by_descripcion("UNIVERSITARIO Y TECNOLOGICO")

    Escuela.reset_column_information
    contador_general=1
    total_escuelas = Escuela.count(:id)
    
    puts("=> Total de escuelas en bd: #{total_escuelas}")
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/clasificacion_prefijos2015.csv").each_line { |line|
      # CLAVE/ACRONIMO	SOSTENIMIENTO	MODALIDAD	MODALIDA ALTERNATIVA PARA USO EN PLATAFORMA
      prefijo, nivel_descripcion, sostenimiento, modalidad, modalidad_alternativa = line.split(",")

      begin
        @escuelas = Escuela.find(:all, :conditions => ["clave like ?", "#{prefijo.strip}%"])
        contador_local=0
        nivel = Nivel.find_by_descripcion(nivel_descripcion.strip) if nivel_descripcion && nivel_descripcion.size > 0
        puts("=>  ----------------------------- Nivel encontrado: #{nivel.descripcion} --------------") if nivel
        unless @escuelas.empty?
          @escuelas.each{|e|
            nivel_escuela = nivel
            nivel_escuela ||= e.nivel
            if nivel_escuela
                e.update_attributes!(:nivel_descripcion => modalidad.strip, :sostenimiento => sostenimiento.strip, :nivel_id => nivel_escuela.id, :modalidad_alternativa => modalidad_alternativa.strip ) if modalidad
                contador_local+=1
                contador_general+=1
            else
              puts("=> #{e.clave} NO TIENE NIVEL ASIGNADO")
            end
          }
          puts ("=>#{prefijo} Total #{modalidad} | #{sostenimiento} | #{nivel.descripcion}: #{contador_local} Actualizadas")
        
        else
          puts("=> Prefijo: #{prefijo} no encontro resultados")
        end
        

      rescue => e
        puts e
      end

     }
     puts("=> Total de escuelas procesadas: #{contador_general}")
     puts("=> Total de escuelas no procesadas: #{total_escuelas - contador_general}")
  end

  def self.down
   puts("=> No tiene accion reversiva")
   #remove_column :escuelas, :sostenimiento
  end


  def self.down
  end
end
