class AddUsersForEachNivel < ActiveRecord::Migration
  def self.up
    Role.create(:name => "nivel", :descripcion => "Nivel Educativo") unless Role.find_by_name("nivel")
    add_column :users, :nivel_id, :integer
    add_column :users, :sostenimiento, :string, :limit => 10

    ### Reorganizo algunos centros de trabajo que no tienen campo de nivel #####
    esc_primarias = Escuela.find(:all, :conditions => ["nombre like ? AND nivel_id IS NULL", 'PRIMARIA%'])
    esc_telesec = Escuela.find(:all, :conditions => ["nombre like ? AND nivel_id IS NULL", 'TELES%'])
    esc_telebach = Escuela.find(:all, :conditions => ["nombre like ? AND nivel_id IS NULL", 'TELEB%'])

    ## Actualizamos registros
    esc_primarias.each do |e| e.update_attributes!(:nivel_id => Nivel.find_by_descripcion("PRIMARIA").id) end 
    esc_telesec.each do |e| e.update_attributes!(:nivel_id => Nivel.find_by_descripcion("SECUNDARIA").id) end
    esc_telebach.each do |e| e.update_attributes!(:nivel_id => Nivel.find_by_descripcion("MEDIA SUPERIOR").id) end

    ## Los que no se encontraron
    esc_otros = Escuela.find(:all, :conditions => ["nivel_id IS NULL"])
    esc_otros.each do |e| e.update_attributes!(:nivel_id => Nivel.find_by_descripcion("OTRO").id) end

    
    #### Crear usuarios por cada nivel encontrado y subsistema #####
    @sostenimientos = ["FEDERAL", "ESTATAL"]
    @sostenimientos.each do |subsistema|
            Nivel.find(:all).each do |nivel|
                login =  subsistema.split("").first +  nivel.descripcion.gsub(/\s/, '')
                password = "#{login}#{nivel.id.to_s}" if login
                usuario = User.new(:login => login,
                      :nombre => "Usuario de #{nivel.descripcion} #{subsistema}",
                      :password => password.downcase,
                      :password_confirmation => password.downcase,
                      :email => "#{login.downcase}@educacionchiapas.gob.mx",
                      :activated_at => Time.now,
                      :nivel_id => nivel.id,
                      :sostenimiento => subsistema
                   ) if login && password
                usuario.roles << Role.find_by_name("nivel") if usuario
                puts("=> Usuario: #{usuario.login} - Password:#{usuario.password}") if (usuario && usuario.save) && usuario.activate!
           end
      end



 

  end





  def self.down
    Role.find_by_name("nivel").destroy if Role.find_by_name("nivel")
    remove_column :users, :nivel_id
    remove_column :users, :sostenimiento
  end
end
