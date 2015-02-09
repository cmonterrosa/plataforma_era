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
    contador_usuarios=0
    ciclo_actual = Ciclo.find_by_activo(true)
    nuevos_usuarios = File.open("tmp/nuevos_usuarios.csv", "w")
    nuevos_usuarios.puts("nombre_escuela,usuario,password,nivel_educativo,subsistema")


    File.open("#{RAILS_ROOT}/db/migrate/catalogos/ultimas_escuelas_beneficiadas_2014.csv").each_line { |line|
       clave, estatus,proyecto,deje1,deje2, deje3,deje4,deje5,total_diagnostico, total_proyecto, total_general, nombre_director = line.split(",")
       begin


       escuela = Escuela.find(:first, :conditions => ["clave = ?", clave.strip])
           if escuela
            estatu_id = (Estatu.find_by_descripcion(estatus))? Estatu.find_by_descripcion(estatus).id : nil
            a = Antecedente.new(:escuela_id => escuela.id,
                                             :clave => clave,
                                             :ciclo_id => ciclo_actual,
                                             :nombre_proyecto => proyecto,
                                             :diagnostico_eje1 => deje1,
                                             :diagnostico_eje2 => deje2,
                                             :diagnostico_eje3 => deje3,
                                             :diagnostico_eje4 => deje4,
                                             :diagnostico_eje5 => deje5,
                                             :puntaje_diagnostico => total_diagnostico,
                                             :puntaje_proyecto => total_proyecto,
                                             :puntaje_final => total_general,
                                             :nombre_director => nombre_director,
                                             :estatu_id => estatu_id
                                      )
            contador+=1 if a.save
            
         ### Actualizamos registros de beneficiada ###
         Escuela.establish_connection "era2014"
          escuela_anterior = Escuela.find(:first, :conditions => ["clave = ?", clave.strip])
          a.update_attributes(:beneficiada => true)
          a.update_attributes(:fecha_beneficiada =>  escuela_anterior.fecha_beneficiada)
          a.save
         Escuela.establish_connection "#{RAILS_ENV}"



         ### Creamos usuarios ###
         User.establish_connection "era2014"
          usuarioa = User.find_by_login(clave)
          login, nombre, email = usuarioa.login, usuarioa.nombre, usuarioa.email
          
         User.establish_connection "#{RAILS_ENV}"

          ## Buscamos si el usuario ya esta registrado ##
          unless User.find_by_login(login)
              usuario = User.new
              password = usuario.make_autopassword
              usuario.update_attributes(:escuela_id => escuela,
                                        :login => login,
                                        :nombre => nombre,
                                        :password => password,
                                        :password_confirmation => password,
                                        :email => email
                                       )
              usuario.activated_at = Time.now

              if usuario.save
                  nivel = (escuela.nivel) ? escuela.nivel.descripcion : "No existe informacion"
                  nuevos_usuarios.puts("#{escuela.nombre},#{login.upcase},#{password},#{nivel}, #{escuela.sostenimiento}")
                  puts("=> #{login.upcase},#{password},#{nivel},#{escuela.sostenimiento}")
                  contador_usuarios +=1

                  ## Cambio de estatus a escuela ###
                  escuela.update_bitacora!("esc-regis", usuario)
              end

          else
            puts("=> Escuela: #{login.upcase} YA ESTA REGISTRADA")

          end

       else
            puts("=> Escuela: #{clave} no encontro resultados")
          end
        rescue => e
            puts e
      end
     }

     puts("=> Total de escuelas encontradas: #{contador}")
     puts("=> Total de usuarios creados: #{contador_usuarios}")

  end

  def self.down
    drop_table :antecedentes
  end
end
