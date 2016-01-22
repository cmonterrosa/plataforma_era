class TruncateUsuarios < ActiveRecord::Migration
  def self.up
    puts("###############  ELIMINANDO USUARIOS ###############")
    @usuarios = User.find(:all, :select => "id, login, escuela_id", :conditions => ["escuela_id IS NOT NULL"])
    @usuarios.each do |u|
      u.roles.destroy && puts("=>Roles eliminados de #{u.login}") if u.login
      u.destroy && puts("=> Usuario eliminado")
    end

    puts("############### LIMPIANDO TABLA DE ESCUELAS ###############")
    execute("update escuelas set registro_completo = NULL;")
    execute("update escuelas set evidencias_internet = NULL;")
    execute("delete from roles_users where user_id NOT IN (select id from users);")
    execute("update escuelas set estatu_id = NULL;")
    execute("
      truncate actividads;

      truncate adjuntos;

      truncate alumnos_capacitados;

      truncate antecedentes;

      truncate avances;

      truncate bitacoras;

      truncate capacitacion_padres;

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

      truncate docentes_capacitados;

      truncate ejes;

      truncate entornos;

      truncate entornos_acciones;

      truncate escuelas_espacios;

      truncate escuelas_generacions;

      truncate escuelas_programas;

      truncate escuelas_users;

      truncate evaluacions;

      truncate huellas;

      truncate huellas_elimina_residuos;

      truncate huellas_inorganicos;

      truncate huellas_servicio_aguas;

      truncate mensajes;

      truncate nivel_certificacions;

      truncate participacions;

      truncate pescolars;

      truncate proyectos;

      truncate ranking_historicos;")
  end

  def self.down
    puts("############### NO TIENE ACCION REVERSIVA ###############")
  end
end
