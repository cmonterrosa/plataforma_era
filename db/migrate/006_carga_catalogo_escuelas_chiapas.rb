class CargaCatalogoEscuelasChiapas < ActiveRecord::Migration
  def self.up

#     ## Agregamos columnas a tabla de escuelas ##
      add_column :escuelas, :cct_zona, :string, :limit => 12
      add_column :escuelas, :cct_sector, :string, :limit => 12
#      #-- Alumnos
      add_column :escuelas, :alu_hom, :integer
      add_column :escuelas, :alu_muj, :integer
      add_column :escuelas, :total_alumnos, :integer
      add_column :escuelas, :grupos, :integer
#
#      #--- Docentes
      add_column :escuelas, :doc_hom, :integer
      add_column :escuelas, :doc_muj, :integer
#      #--- Directivos ---
      add_column :escuelas, :dsg_muj, :integer
      add_column :escuelas, :dsg_hom, :integer
      add_column :escuelas, :total_dsg, :integer
#      #--- Personal de apoyo
      add_column :escuelas, :apoyo_hom, :integer
      add_column :escuelas, :apoyo_muj, :integer
#
#      # Descripcion
      add_column :escuelas, :descripcion, :string, :limit => 60
      add_column :escuelas, :nivel_descripcion, :string, :limit => 30
      add_column :escuelas, :region_descripcion, :string, :limit => 30
      add_column :escuelas, :inc_cer, :integer

      ## Numero de escuelas para el caso de supervisiones
      add_column :escuelas, :escuelas, :integer


      ## Indices ###
      add_index :escuelas, :cct_zona, :name => "cct_zona"
      ## Descripcion de nivel
      add_index :nivels, :descripcion, :name => "descripcion_nivel"

      #---- Cargamos el catalogo de escuelas ------
      contador=1
      File.open("#{RAILS_ROOT}/db/migrate/catalogos/escuelas_actualizadas.csv").each_line { |line|
      ##"07DCC0206C","LOS NIÑOS HEROES",1    , "CHILON"             , "SAN GABRIEL"         ,"SAN GABRIEL",0,109,"07FZI0004J",1,"07FJI0001L",1,15,9,24,3,1,0,1,0,0,0,0,0,0,"PREESCOLAR","PREESCOLAR INDIGENA FEDERAL TRANSFERIDO",6,"VI SELVA",1,,
      #CLAVE_ESC, NOMBRE DE LA ESCUELA, TURNO,	NOMBRE DEL MUNICIPIO,	NOMBRE DE LA LOCALIDAD,	DOMICILIO DE LA ESCUELA,	TELEFON,	ZONESC,	CCT ZONA,	SECTOR,	CCT SECTOR,	ESCUELAS	ALU_HOM	ALU_MUJ	ALUMNOS	GRUPOS	DTE_HOM	DTE_MUJ	DOCENTES	DSG_H	DSG_M	DSG_T	PERS_APOYO_H	PERS_APOYO_M	PERS_APOYO_T	DESCRIPCION NIVEL	NOMBRE DE LA MODALDAD	REG_ECO	DESC_REG	INC. P/CER

     begin
      clave,nombre,turno,municipio,localidad,domicilio,telefono,zona_escolar,cct_zona,sector,cct_sector,escuelas, alu_hom, alu_muj, total_alumnos, grupos, doc_hom, doc_muj, total_docentes, dsg_hom, dsg_muj, total_dsg, apoyo_hom, apoyo_muj, total_personal_apoyo, nivel_descripcion, modalidad, region, region_descripcion, inc_cer = line.split("|")
      @e = Escuela.new(:clave => clave,
                  :nombre => nombre,
                  :turno => turno,
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
                  :region => region,
                  :region_descripcion => region_descripcion,
                  :inc_cer => inc_cer
                 )
         ## LE PEGAMOS NIVEL EDUCATIVO ####
         nivel = Nivel.find_by_descripcion(nivel_descripcion)
         @e.nivel_id = nivel.id if nivel
         if @e.save
            puts "=> E #{contador}"
            contador+=1
         end

      rescue => e
        puts e
      end
     }
    
  end

  def self.down
    Escuela.find(:all).each do |x| x.destroy end
  end
end
