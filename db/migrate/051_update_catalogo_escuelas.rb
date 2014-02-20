class UpdateCatalogoEscuelas < ActiveRecord::Migration
    def self.up
      turnos = {"1" => "MATUTINO", "2" => "VESPERTINO"}
      contador=1
      out_file = File.new("#{RAILS_ROOT}/db/migrate/catalogos/agregadas2014.csv", "w")
      File.open("#{RAILS_ROOT}/db/migrate/catalogos/escuelas_actualizadas2014.csv").each_line { |line|
      #----- Nueva estructura --
      #07ETV0454O|TELESECUNDARIA 054 ELISEO MELLANES CASTELLANOS|1|LA CONCORDIA|RIZO DE ORO|RIZO DE ORO|0|027|07FTV0027U|09|07FTS0009R|1|63|59|122|6|5|1|6|||0||||TELESECUNDARIA ESTATAL|SECUNDARIA|REGION VI|VI  FRAILESCA|
      #
      #
      #---- Vieja estructura ----
      #"07DCC0206C","LOS NIÑOS HEROES",1    , "CHILON"             , "SAN GABRIEL"         ,"SAN GABRIEL",0,109,"07FZI0004J",1,"07FJI0001L",1,15,9,24,3,1,0,1,0,0,0,0,0,0,"PREESCOLAR","PREESCOLAR INDIGENA FEDERAL TRANSFERIDO",6,"VI SELVA",1,,
      #CLAVE_ESC, NOMBRE DE LA ESCUELA, TURNO,	NOMBRE DEL MUNICIPIO,	NOMBRE DE LA LOCALIDAD,	DOMICILIO DE LA ESCUELA,	TELEFON,	ZONESC,	CCT ZONA,	SECTOR,	CCT SECTOR,	ESCUELAS	ALU_HOM	ALU_MUJ	ALUMNOS	GRUPOS	DTE_HOM	DTE_MUJ	DOCENTES	DSG_H	DSG_M	DSG_T	PERS_APOYO_H	PERS_APOYO_M	PERS_APOYO_T	DESCRIPCION NIVEL	NOMBRE DE LA MODALDAD	REG_ECO	DESC_REG	INC. P/CER

     begin
      clave,nombre,turno,municipio,localidad,domicilio,telefono,zona_escolar,cct_zona,sector,cct_sector,escuelas, alu_hom, alu_muj, total_alumnos, grupos, doc_hom, doc_muj, total_docentes, dsg_hom, dsg_muj, total_dsg, apoyo_hom, apoyo_muj, total_personal_apoyo, nivel_descripcion, modalidad, region,  = line.split("|")

        #### Buscamos si existe la escuela ####
        unless Escuela.find_by_clave(clave)
             @e = Escuela.new(:clave => clave,
                  :nombre => nombre,
                  :turno => turnos["#{turno.strip}"],
                  :municipio => municipio,
                  :localidad => localidad,
                  :domicilio => domicilio,
                  :telefono => telefono,
                  :zona_escolar => zona_escolar,
                  :cct_zona => cct_zona,
                  :sector => sector,
                  :cct_sector => cct_sector,
                  :escuelas => escuelas,
                  :alu_hom => alu_hom,
                  :alu_muj => alu_muj,
                  :total_alumnos => total_alumnos,
                  :grupos => grupos,
                  :doc_hom => doc_hom,
                  :doc_muj => doc_muj,
                  :total_personal_docente => total_docentes,
                  :dsg_hom => dsg_hom,
                  :dsg_muj => dsg_muj,
                  :total_dsg => total_dsg,
                  :apoyo_hom => apoyo_hom,
                  :apoyo_muj => apoyo_muj,
                  :total_personal_apoyo => total_personal_apoyo,
                  :nivel_descripcion => nivel_descripcion,
                  :modalidad => modalidad,
                  :region => region
                 )
                 
              
              nivel = Nivel.find_by_descripcion(nivel_descripcion)
              @e.nivel_id = nivel.id if nivel
              if @e.save
                 puts "=> #{nombre}"
                 contador+=1
                 out_file.puts(line)
              end
          end

      rescue => e
        puts e
      end
     }
    out_file.close
 end


  def self.down
    puts("Deshacemos escuelas actualizadas")
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/agregadas2014.csv").each_line { |line|
      clave,nombre,turno,municipio,localidad,domicilio,telefono,zona_escolar,cct_zona,sector,cct_sector,escuelas, alu_hom, alu_muj, total_alumnos, grupos, doc_hom, doc_muj, total_docentes, dsg_hom, dsg_muj, total_dsg, apoyo_hom, apoyo_muj, total_personal_apoyo, nivel_descripcion, modalidad, region,  = line.split("|")
      esc = Escuela.find_by_clave(clave)
      if esc && esc.destroy
         puts "=> Eliminada"
      end
    }
    File.delete("#{RAILS_ROOT}/db/migrate/catalogos/agregadas2014.csv")
  end
end


