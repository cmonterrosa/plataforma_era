class NuevoCicloEscolar2015 < ActiveRecord::Migration
  def self.up
   #### REINICIANDO TABLAS PARA NUEVO CICLO ESCOLAR ###
  puts("############### CICLO 2014 - 2015 ###############")
  queries="truncate actividads;
  truncate avances;
  truncate bitacoras;
  truncate comentarios;
  truncate competencias;
  truncate consumos;
  truncate consumos_alimentos;
  truncate consumos_bebidas;
  truncate consumos_botanas;
  truncate consumos_establecimientos;
  truncate consumos_higienes;
  truncate consumos_materials;
  truncate consumos_preparacions;
  truncate consumos_reposterias;
  truncate consumos_utensilios;
  truncate cortes;
  truncate diagnosticos;
  truncate directivos;
  truncate ejes;
  truncate entornos;
  truncate entornos_acciones;
  truncate escuelas_users;
  truncate evaluacions;
  truncate huellas;
  truncate huellas_elimina_residuos;
  truncate huellas_inorganicos;
  truncate mensajes;
  truncate participacions;
  truncate proyectos;
  truncate ranking_historicos;
  truncate roles_users;
  truncate users";

    queries.split(";").each do |c| execute(c.strip + ";") end
    puts("=> AJUSTANDO TABLA DE ESCUELAS")
    total_escuelas = Escuela.count(:id)
    puts("=> Total de Escuelas: #{total_escuelas}")
    contador=1
    Escuela.find(:all, :conditions => ["estatu_id IS NOT NULL"]).each do |e|
    e.update_attributes(:created_at => Time.now,
                                      :nombre_proyecto => nil,
                                      :responsables_proyecto => nil,
                                      :tel_responsable_proyecto => nil,
                                      :email_responsable_proyecto => nil,
                                      :estatu_id => nil,
                                      :registro_completo => nil,
                                      :agregada_usuario => 0,
                                      :beneficiada => nil,
                                      :fecha_beneficiada => nil)
     puts("=> #{contador} Actualizada") if e.save
    end

    puts ("=> BORRANDO ARCHIVOS")
    contador_archivos=1
    @adjuntos = Adjunto.all.each do |a|
          contador_archivos+=1 if a.destroy
    end
    puts("=> ADJUNTOS BORRADOS: #{contador_archivos}")
    execute("truncate adjuntos;")
  end


  def self.down
  end
end
