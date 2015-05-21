class ReorganizacionPrefijosModalidades < ActiveRecord::Migration

  def self.up
    add_column :escuelas, :modalidad_alternativa, :string, :limit => 75
    Nivel.create(:clave => 8, :descripcion => "INICIAL") unless Nivel.find_by_descripcion("INICIAL")
    Nivel.create(:clave => 9, :descripcion => "MISIONES CULTURALES") unless Nivel.find_by_descripcion("MISIONES CULTURALES")
    Nivel.create(:clave => 10, :descripcion => "CAPACITACION PARA EL TRABAJO") unless Nivel.find_by_descripcion("CAPACITACION PARA EL TRABAJO")
    Nivel.create(:clave => 11, :descripcion => "PROFESIONAL MEDIO") unless Nivel.find_by_descripcion("PROFESIONAL MEDIO")
    Nivel.create(:clave => 11, :descripcion => "NORMAL LICENCIATURA") unless Nivel.find_by_descripcion("NORMAL LICENCIATURA")
    Nivel.create(:clave => 12, :descripcion => "UNIVERSITARIO Y TECNOLOGICO") unless Nivel.find_by_descripcion("UNIVERSITARIO Y TECNOLOGICO")

    Escuela.reset_column_information
    contador_general=1
    total_escuelas = Escuela.count(:id)
    estatu_inicio_registro = Estatu.find_by_clave("esc-regis")
    estatu_registro_completo = Estatu.find_by_clave("esc-datos")
    puts("=> Total de escuelas en bd: #{total_escuelas}")
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/clasificacion_prefijos2015.csv").each_line { |line|
      # CLAVE/ACRONIMO	SOSTENIMIENTO	MODALIDAD	MODALIDA ALTERNATIVA PARA USO EN PLATAFORMA
      prefijo, nivel_descripcion, sostenimiento, modalidad, modalidad_alternativa = line.split(",")
       
      begin
        @escuelas = Escuela.find(:all, :select => "id, clave, nivel_id, estatu_id, registro_completo, modalidad, modalidad_alternativa, sostenimiento", :conditions => ["clave like ?", "#{prefijo.strip}%"])
        contador_local=0
        nivel = Nivel.find(:first, :conditions => ["descripcion = ?", nivel_descripcion.strip]) if nivel_descripcion if nivel_descripcion && nivel_descripcion.size > 0
        puts("=>  ----------------------------- NIVEL ENCONTRADO: #{nivel.descripcion} --------------") if nivel
        unless @escuelas.empty?
          @escuelas.each{|e|
            nivel_escuela = nivel
            nivel_escuela ||= e.nivel
            if nivel_escuela
              sostenimiento_escuela = e.sostenimiento.strip if e.sostenimiento
              sostenimiento_escuela ||= sostenimiento.strip if sostenimiento

              modalidad_escuela = e.modalidad
              modalidad_escuela ||= modalidad
              modalidad_alternativa_escuela = modalidad_alternativa.strip if modalidad_alternativa

              if e.participo_generacion("2013-2014") || e.participo_generacion("2014-2015")
                unless e.estatu_id
                  if e.registro_completo
                      e.update_attributes(:estatu_id => estatu_registro_completo.id)
                      puts("=> #{e.clave} SE ACTUALIZO A DATOS BASICOS CAPTURADOS ")
                  else
                      e.update_attributes(:estatu_id => estatu_inicio_registro.id)
                      puts("=> #{e.clave} SE ACTUALIZO A ESCUELA REGISTRADA EN PLATAFORMA ")
                  end
                end
              end

              e.update_attributes(:modalidad => modalidad_escuela,
                  :nivel_id =>nivel_escuela.id,
                  :sostenimiento => sostenimiento_escuela,
                  :modalidad_alternativa => modalidad_alternativa_escuela)
                
              if e.save
                  contador_local+=1
                  contador_general+=1
              end
            else
              puts("=> #{e.clave} NO TIENE NIVEL ASIGNADO")
            end
          }
          puts ("=>#{prefijo} : #{contador_local} ACTUALIZADAS (#{modalidad}) | (#{sostenimiento}) | #{nivel.descripcion}") if nivel
        
        else
          puts("=> ******** Prefijo: #{prefijo} SIN RESULTADOS")
        end
        

      rescue => e
        puts e
      end

     }
     puts("=> TOTAL DE ESCUELAS PROCESADAS: #{contador_general}")
  end

  def self.down
   puts("=> No tiene accion reversiva")
   #remove_column :escuelas, :sostenimiento
  end


  def self.down
  end
end
