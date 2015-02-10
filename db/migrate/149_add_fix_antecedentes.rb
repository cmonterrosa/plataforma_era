class AddFixAntecedentes < ActiveRecord::Migration
  def self.up
    puts("=> Buscamos registros de beneficiadas que no esten en users")
    usuarios = User.find(:all, :select => "login")
    no_capturados = Antecedente.find(:all, :conditions => ["clave not in (?)", usuarios.map{|i|i.login}])
    puts("=> Total de registros encontrados: #{no_capturados.size}")
    contador_usuarios=0
    nuevos_usuarios = File.open("tmp/usuarios_fix.csv", "w")
    nuevos_usuarios.puts("nombre_escuela,usuario,password,nivel_educativo,subsistema")


    no_capturados.each do |nc|
           escuela = Escuela.find(:first, :conditions => ["clave = ?", nc.clave])
           if escuela

            ### Creamos usuarios ###
            User.establish_connection "era2014"
              usuarioa = User.find_by_login(nc.clave)
              login, nombre, email = usuarioa.login, usuarioa.nombre, usuarioa.email
            User.establish_connection "#{RAILS_ENV}"


              unless User.find_by_login(login)
                  usuario = User.new
                  password = usuario.make_autopassword
                  usuario.update_attributes(:escuela_id => escuela,
                                            :login => login,
                                            :nombre => nombre,
                                            :password => password,
                                          :password_confirmation => password,
                                          :email => "#{login}@educacionchiapas.gob.mx"
                                       )
                  usuario.activated_at = Time.now
                  

                  if usuario.save
                      nivel = (escuela.nivel) ? escuela.nivel.descripcion : "No existe informacion"
                      nuevos_usuarios.puts("#{escuela.nombre},#{login.upcase},#{password},#{nivel}, #{escuela.sostenimiento}")
                      puts("=> #{login.upcase},#{password},#{nivel},#{escuela.sostenimiento}")
                      contador_usuarios +=1

                      ## Cambio de estatus a escuela ###
                      escuela.update_bitacora!("esc-regis", usuario)
                  else
                    puts("=> No se pudo guardar #{escuela.clave} | #{escuela.errors.map{|i| i}}" )
                    end
              else
                     puts("=> Ya existe usuario: #{escuela.clave}" )
                end
           else
               puts("=> No existe escuela: #{nc.clave}" )
           end
    end
  end



      
  

  def self.down
  end
end
