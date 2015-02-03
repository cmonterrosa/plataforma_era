class CreateAntecedentes < ActiveRecord::Migration
  def self.up
    create_table :antecedentes do |t|
      
      ## Relacion con otras tablas ##
      t.integer :escuela_id
      t.string :clave, :limit => 11
      t.integer :ciclo_id
      t.integer :estatu_id


      ## Datos generales ##
      t.integer :beneficiada
      t.date :fecha_beneficiada
      t.string :nombre_director, :limit => 120
      t.string :observaciones, :limit => 120


      ## Datos especificos diagnostico ##
      t.string :diagnostico_eje1, :limit => 10
      t.string :diagnostico_eje2, :limit => 10
      t.string :diagnostico_eje3, :limit => 10
      t.string :diagnostico_eje4, :limit => 10
      t.string :diagnostico_eje5, :limit => 10


      # Datos del Proyecto
       t.string :nombre_proyecto, :limit => 160
       t.string :puntaje_diagnostico, :limit => 10
       t.string :puntaje_proyecto, :limit => 10
       t.string :puntaje_final, :limit => 10
       t.timestamps
    end

    add_index :antecedentes, :escuela_id, :name => "antecedentes_escuela"
    add_index :antecedentes, [:escuela_id, :ciclo_id], :name => "antecedentes_escuela_ciclo"
    add_index :antecedentes, [:beneficiada, :ciclo_id], :name => "antecedentes_beneficiadas_ciclo"


    ### Actualizacion de informacion ###

   #CLAVE_ESCUELA	ESTATUS_ACTUAL	PROYECTO	DIAGNOSTICO_EJE1	DIAGNOSTICO_EJE2	DIAGNOSTICO_EJE3	DIAGNOSTICO_EJE4	DIAGNOSTICO_EJE5	TOTAL_DIAGNOSTICO	TOTAL_PROYECTO	TOTAL_GENERAL	NOMBRE_DIRECTOR

    puts("=> Actualizamos escuelas beneficiadas")
    contador=0
    ciclo_actual = Ciclo.find_by_activo(true)
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/ultimas_escuelas_beneficiadas_2014.csv").each_line { |line|
       clave, estatus,proyecto,deje1,deje2, deje3,deje4,deje5,total_diagnostico, total_proyecto, total_general, nombre_director = line.split(",")
       begin
       
        Escuela.establish_connection "era2014"
        puts clave
        escuela = Escuela.find(:first, :conditions => ["clave = ?", clave.strip])
           if escuela
            estatu_id = (Estatu.find_by_descripcion(estatus)) ? Estatu.find_by_descripcion(estatus).id : 1
            a = Antecedente.new(:escuela_id => escuela,
                                             :clave => clave,
                                             :ciclo_id => ciclo_actual
                                             )
            contador+=1 if a.save
          else
            puts("=> Escuela: #{clave} no encontro resultados")
          end
        rescue => e
            puts e
      end
     }
       puts("=> Total de escuelas encontradas: #{contador}")

    


  end

  def self.down
    drop_table :antecedentes
  end
end
