class ResetarDiagnosticos < ActiveRecord::Migration
  def self.up
   #### REINICIANDO TABLAS PARA NUEVO CICLO ESCOLAR ###
  puts("############### RESETEANDO DIAGNOSTICO ###############")
  queries="truncate actividads;
  truncate avances;
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
  truncate proyectos;";

    queries.split(";").each do |c| execute(c.strip + ";") end
    puts("=> AJUSTANDO ESCUELAS QUE HICIERON DIAGNOSTICO")
    estatus = Estatu.find(:all, :conditions => ["clave in (?)", ["diag-inic", "diag-conc", "proy-inic", "proy-fin", "avance1", "avance2"]])
    estatu_solo_registro = Estatu.find(:first, :conditions => ["clave = ?", "esc-datos"])
    total_escuelas = Escuela.count(:id, :conditions => ["estatu_id in (?)", estatus])
    puts("=> Total de Escuelas con diagnostico trabajado: #{total_escuelas}")
    contador=1
    total_escuelas = Escuela.find(:all, :conditions => ["estatu_id in (?)", estatus]).each do |e|
      e.update_attributes(:estatu_id => estatu_solo_registro.id)
      puts("=> TOTAL DE ESCUELAS ACTUALIZADAS: #{contador}") if e.save && contador+=1
    end

    puts ("=> BUSCANDO ARCHIVOS")
    contador_archivos=0
    @adjuntos = Adjunto.all.each do |a|
      file_exists = File.exists?(a.full_path)
      deleted = (file_exists)? a.destroy : nil
      (deleted) ?  contador_archivos+=1 : nil
    end
    puts("=> ADJUNTOS BORRADOS: #{contador_archivos}")
    execute("truncate adjuntos;")
  end


  def self.down
  end
end
