class AddValidacionRegistroCompleto < ActiveRecord::Migration
  def self.up
    add_column :escuelas, :registro_completo, :boolean


    #### Actualizamos las que ya tienen registro completo ####
    datos_basicos = Estatu.find_by_clave("esc-datos")
    users = Bitacora.find_by_sql("select distinct(user_id) from  era.bitacoras where estatu_id=#{datos_basicos.id}")
    users.each do |u|
      usuario = User.find(u.user_id)
      if usuario.escuela
        usuario.escuela.update_attributes!(:registro_completo => true)
        puts "#{usuario.escuela.clave} creada"
      end

    end




  end

  def self.down
    remove_columns :escuelas, :registro_completo
  end
end
