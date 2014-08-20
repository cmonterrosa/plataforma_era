require 'fastercsv'
class AdminController < ApplicationController
  #protect_from_forgery
  require_role [:directivo], :only => [:show_escuelas]
  require_role [:admin], :for => ["show_respaldos"]
  require_role [:admin, :adminplat]


  
  def index
  end

  ### Control de usuarios #####
  def new_from_admin
    @user = User.new
  end

  # create user from admin role not need activation
  def save_new_user
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    @user.email_not_required!
    ## Main Role ###
    @user.roles << Role.find(params[:role][:id])
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Usuario creado correctamente"
      redirect_to :action => "show_users", :controller => "admin"
    else
      flash[:notice]  = "No se puedo crear usuario, verifique los datos"
      render :action => 'new_from_admin'
    end
  end

  def edit_user
    @user = User.find_by_login(params[:id])
  end

  def save
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
    escuela = Escuela.find_by_clave(@user.login)? Escuela.find_by_clave(@user.login) : nil
    success = @user && @user.save
    if success && @user.errors.empty?
      ##### Actualizamos escuela si es el caso ####
      escuela.update_attributes!(:nombre => params["escuela"]["nombre"]) if current_user.has_role?("adminplat") && params["escuela"]["nombre"]
      flash[:notice] = "Los datos se actualizaron correctamente"
      redirect_to :controller => "admin", :action => "show_users"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit'
    end
  end

  def show_roles
    @roles = Role.find(:all)
  end

  def show_users
    @usuarios = User.find(:all, :order => "created_at").paginate(:page => params[:page], :per_page => 15)
#    render :partial => "show_users" if params[:actualizar] == "SI"
  end

  def show_escuelas
    @escuelas = Escuela.find(:all, :conditions => ["cct_zona = ?", current_user.login.upcase], :order => "nombre").paginate(:page => params[:page], :per_page => 25)
    flash[:error] = nil
   # render :text => @escuelas.collect{|x|x.inspect}
  end

  def block_user
    if @user = User.find_by_login(params[:id])
      @mensaje = @user.blocked ? "Usuario reactivado" : "Usuario bloqueado"
      (@user.blocked) ? @user.update_attributes!(:blocked => false) : @user.update_attributes!(:blocked => true)
      flash[:notice] = @mensaje
    else
      flash[:notice] = "No se pudo bloquear usuario, verifique"
    end
    redirect_to :action => "show_users"
  end
 #------- Administracion de Roles ---------
  def members_by_role
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
      unless @role.users.include?(user)
        @users << user
      end
    }
  end

  def add_user
    @role = Role.find(params[:role])
    @role.users << User.find(params[:user][:user_id])
    if @role.save
      flash[:notice] = "Usuario agregado correctamente"
    else
      flash[:notice] = "El usuario no fue agregado, verifique"
    end
    redirect_to :action => "members_by_role", :id => @role
  end

  def new_user
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
      unless @role.users.include?(user)
        @users << user
      end
    }
  end

  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
    @role.users.delete(@user)
    if @role.save!
      flash[:notice] = "Elemento eliminado del perfil correctamente"
    else
      flash[:notice] = "No se pudo eliminar, verifique"
    end
      redirect_to :action => "members_by_role", :id => @role
  end

  def show_roles
    @roles = Role.find(:all)
  end

  def show_diagnostico
    @escuela = Escuela.find(params[:id]) if params[:id]
    if @escuela && @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id)
      redirect_to :action => "reporte", :controller => "diagnosticos", :id => @diagnostico
    else
      flash[:error] = "Centro Escolar no cuenta con diagnóstico"
      redirect_to :action => "show_users", :id => @diagnostico
    end
  end

  #--- Comentarios
  def show_comentarios
    @comentarios = Comentario.find(:all)
    render :partial => "show_comentarios" if params[:actualizar] == "SI"
  end

  def show_comentario_detalle
    @comentario = Comentario.find(params[:id])
    return render(:partial => 'buzon/show', :layout => "only_jquery")
  end

  def destroy_comentario
    @comentario = Comentario.find(params[:id])
    (@comentario.destroy) ? flash[:notice] = "Comentario eliminado correctamente" : flash[:error] = "No se pudo eliminar comentario"
    redirect_to :action => "show_comentarios"
  end

  def indicadores
      @gran_total=0
    @escuelas_registradas_en_plataforma = Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("esc-regis").id ])
      @gran_total+=@escuelas_registradas_en_plataforma
    @escuelas_datos_basicos_capturados =  Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("esc-datos").id ])
      @gran_total+=@escuelas_datos_basicos_capturados
    @escuelas_diagnostico_iniciado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("diag-inic").id ])
      @gran_total+=@escuelas_diagnostico_iniciado
    @escuelas_diagnostico_terminado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("diag-conc").id ])
      @gran_total+=@escuelas_diagnostico_terminado
    @escuelas_proyecto_iniciado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("proy-inic").id ])
      @gran_total+=@escuelas_proyecto_iniciado
    @escuelas_proyecto_terminado =      Escuela.count(:id, :joins => "escuelas, users users", :conditions => ["users.login=escuelas.clave AND escuelas.estatu_id = ? AND (users.blocked is NULL OR  users.blocked !=1)", Estatu.find_by_clave("proy-fin").id ])
      @gran_total+=@escuelas_proyecto_terminado
    @total_escuelas_ingresadas = @gran_total
    #@total_escuelas_ingresadas =          User.count(:id, :joins => "users, escuelas e", :conditions => "users.login=e.clave AND (users.blocked is NULL OR  users.blocked !=1)")
    @directivos_escolares_registrados =   Directivo.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("dir-regis") ])
    render :partial => "indicadores" if params[:actualizar] == "SI"
  end

  def findEscuela
    @escuela = Escuela.find_by_clave(params[:clave])
    if @escuela.nil?
      flash[:error] = "No existe escuela con esa clave"
    else
      flash[:error] = nil
    end
    render :partial => "find_escuela"
  end

  def showEscuelas
    @escuelas = Escuela.find(:all, :conditions => ["cct_zona = ?", current_user.login.upcase], :order => "nombre").paginate(:page => params[:page], :per_page => 25)
    if params[:actualizar].to_i == 1
      @load = 0
    else
      @load = 1
    end
    flash[:error] = nil
    render :partial => "load_escuelas", :layout => true
  end

  def updateUsers
    @usuarios = User.find(:all, :order => "created_at").paginate(:page => params[:page], :per_page => 15)
    if params[:actualizar].to_i == 1
      @load = 0
    else
      @load = 1
    end
    flash[:error] = nil
    render :partial => "update_users", :layout => true
  end

  def showResults
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.clave like '%#{params[:clave_nombre].to_s}%'
                               OR usr.login like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "nombre")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on esc.id = usr.escuela_id
                               WHERE esc.nombre like '%#{params[:clave_nombre].to_s}%'
                               OR usr.nombre like '%#{params[:clave_nombre].to_s}%'") if (params[:buscar] == "clave")
    @users = User.find_by_sql("SELECT usr.* FROM users as usr
                               LEFT JOIN escuelas as esc on usr.escuela_id = esc.id
                               WHERE esc.estatu_id = #{params[:estatus_escuela].to_i}") if (params[:buscar] == "estatus")
    
    if @users.nil? or @users.empty?
      flash[:error] = "No se encontraron registros con el criterio de busqueda especificado"
    else
      @usuarios = @users.paginate(:page => params[:page], :per_page => 15)
      flash[:error] = nil
    end

    if request.get?
      if params[:find].to_i == 1
        @load = 1
      else
        @load = 0
      end
    end
    
    render :partial => "show_results", :layout => true
  end

  def total_escuelas_registradas
    @escuelas = User.find(:all, :select => "users.created_at as user_created_at, users.login, users.id as user_id, e.*", :joins => "users, escuelas e", :conditions => "users.login=e.clave AND (users.blocked is NULL OR  users.blocked !=1)")
    csv_string = FasterCSV.generate(:col_sep => ",") do |csv|
      csv << ["CLAVE_ESCUELA", "NOMBRE", "ZONA_ESCOLAR",       "SECTOR",          "NIVEL",           "DOMICILIO",     "LOCALIDAD",   "MUNICIPIO",      "REGION",              "MODALIDAD",  "CORREO_ESCUELA",   "CORREO_RESPONSABLE",    "TELEFONO_ESCUELA", "TELEFONO_DIRECTOR", "FECHA_HORA_CAPTURA", "ALU_HOMBRES", "ALU_MUJERES", "TOTAL_ALUMNOS", "GRUPOS", "TOTAL_ALUMNOS",       "DOCENTES_H", "DOCENTES_M",  "TOTAL_DOCENTE_APOYO",              "TOTAL_PERSONAL_ADMVO",   "TOTAL_PERSONAL_APOYO", "ESTATUS_ACTUAL", "DOCENTES_CAPACITADOS", "DOCENTES_INVOLUCRADOS", "ALUMNOS_CAPACITADOS", "SUPERFICIE_AREAS_VERDES", "ARBOLES_ADULTOS", "ACCIONES_MANUAL_DE_SALUD", "CAPACITACION_AHORRO_DE_ENERGIA", "CONSUMO_ENERGIA_ELECTRICA", "FOCOS_AHORRADORES", "RED_PUBLICA_AGUA", "PROYECTO"]
      @escuelas.each do |i|
        diagnostico= Diagnostico.find(:first, :conditions => ["escuela_id = ?", i["id"]]) if i["id"]
        proyecto = Proyecto.find(:first, :conditions => ["diagnostico_id = ?", diagnostico.id]) if diagnostico
        proyecto = (proyecto) ? proyecto.descripcion : ""
        # campos diagnostico
        if User.find_by_id(i.user_id)
            # -- competencia
            docentes_capacitados = diagnostico.competencia ? diagnostico.competencia.docentes_capacitados_sma : ""
            docentes_involucrados = diagnostico.competencia ? diagnostico.competencia.docentes_involucran_actividades : ""
            alumnos_capacitados = diagnostico.competencia ? diagnostico.competencia.alumnos_capacitados_docentes : ""

            # -- entorno
            superficie_areas_verdes = diagnostico.entorno ? diagnostico.entorno.superficie_terreno_escuela_av : ""
            arboles_adultos = diagnostico.entorno ? diagnostico.entorno.arboles_terreno_escuela : ""

            if diagnostico.entorno and diagnostico.entorno.acciones
              array_acciones = []
              diagnostico.entorno.acciones.each do |a|
                array_acciones << a.descripcion
              end
              acciones = array_acciones.join(";")
            end
            acciones ||= ''

            # -- huella
            capacitacion_ahorro_energia = diagnostico.huella ? diagnostico.huella.capacitacion_ahorro_energia : ""

            if diagnostico.huella.consumo_anterior.to_f >= 0 and diagnostico.huella.energia_electrica.nil?
              consumo_energia = "Anterior: #{diagnostico.huella.consumo_anterior} - Actual: #{diagnostico.huella.consumo_actual}"
            else
              consumo_energia = diagnostico.huella.energia_electrica.descripcion
            end if diagnostico.huella
            consumo_energia ||= ''

            focos_ahorradores = diagnostico.huella ? diagnostico.huella.focos_ahorradores : ""

            unless diagnostico.huella.servicio_agua.nil?
              red_publica_agua = diagnostico.huella.servicio_agua.descripcion
            else
              red_publica_agua = diagnostico.huella.red_publica_agua
            end if diagnostico.huella
            red_publica_agua ||= ''

#            if diagnostico.huella.recip_residuos_solid == "SI"
#              recip_residuos_solidos = diagnostico.huella.recip_residuos_solid
#            else
#              array_recip = []
#              diagnostico.huella.elimina_residuos.each do |r|
#                array_recip << r.descripcion
#              end
#              recip_residuos_solidos = array_recip.join(";")
#            end
#            recip_residuos_solidos ||= ''

            # --
          end unless diagnostico.nil?

        estatus_actual = Estatu.find(i['estatu_id']) ? Estatu.find(i['estatu_id']).descripcion : "No existe información"  if i['estatu_id']
        csv << [ i["clave"], i["nombre"], i['zona_escolar'],  i['sector'], i['nivel_descripcion'],  i["domicilio"], i["localidad"], i['municipio'], i['region_descripcion'], i['modalidad'], i["email"], i["email_responsable_proyecto"], i["telefono"], i["telefono_director"], i['user_created_at'], i['alu_hom'], i['alu_muj'], i['total_alumnos'], i['grupos'], i['total_alumnos'],  i['doc_hom'], i['doc_muj'], i["total_personal_docente_apoyo"], i['total_personal_admvo'], i["total_personal_apoyo"], estatus_actual, docentes_capacitados, docentes_involucrados, alumnos_capacitados, superficie_areas_verdes, arboles_adultos, acciones, capacitacion_ahorro_energia, consumo_energia, focos_ahorradores, red_publica_agua, proyecto]
      end
    end
    send_data csv_string, type => "text/plain",
               :filename => "escuelas_ESyS_#{Time.now.strftime("%d-%m-%Y_%I%M_%p")}.csv",
               :disposition => "attachment"
  end



  def add_comunitaria
#    @escuela = Escuela.new
  end

  def save_comunitaria
    unless Escuela.find_by_clave(params[:escuela][:clave].strip)
      @escuela = Escuela.new
      nivel = params[:comunitaria] ? Nivel.find_by_descripcion("COMUNITARIA") : Nivel.find_by_clave(params[:escuela][:nivel_id])
      @escuela.clave = params[:escuela][:clave].strip
      
      if params[:comunitaria]
        @escuela.comunitaria = true
        @escuela.nivel_id = nivel.id if nivel
        @escuela.nivel_descripcion = nivel.descripcion if nivel
      else
        @escuela.agregada_usuario = true
        @escuela.nivel_id = nivel.id if nivel
        @escuela.nivel_descripcion = nivel.descripcion if nivel
      end

      if @escuela.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "admin"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        render :action => "add_comunitaria"
      end
    else
      flash[:error] = "La Clave de escuela ya existe, verifique los datos"
      render :action => "add_comunitaria"
    end
  end

  def menu_diagnostico
    @escuela = Escuela.find(params[:id])
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id)
    render :partial => "show_diagnostico", :layout => "era2014"
  end


  ###############################################################################
  #  Funciones para habilitar y deshabilitar diagnostico y proyecto (solo admin)
  #
  ###############################################################################


  def habilitar_diagnostico
    @diagnostico = Diagnostico.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @diagnostico.oficializado = false
    if @diagnostico.save
      flash[:notice] = "Diagnóstico habilitado"
    else
      flash[:notice] = "DIagnóstico no se pudo habilitar"
    end
    redirect_to :action => "menu_diagnostico", :id => @escuela
  end

  def habilitar_proyecto
    @proyecto = Proyecto.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @proyecto.oficializado = false
    if @proyecto.save
      flash[:notice] = "Proyecto habilitado"
    else
      flash[:notice] = "Proyecto no se pudo habilitar"
    end
    redirect_to :action => "menu_proyecto", :id => @escuela, :diagnostico => @proyecto.diagnostico
  end
  
  def habilitar_avance
    @num_avance = params[:num_avance]
    @proyecto = Proyecto.find(params[:id])
    @escuela = Escuela.find(params[:escuela])
    @proyecto.avance = @num_avance.to_i
    if @proyecto.save
      flash[:notice] = "Avance #{@num_avance} habilitado"
    else
      flash[:notice] = "Avance #{@num_avance} no se pudo habilitar"
    end
    redirect_to :action => "menu_proyecto", :id => @escuela, :diagnostico => @proyecto.diagnostico
  end

  ###### RESPALDOS #################

  def show_respaldos
    @respaldos = Dir.glob("#{BACKUPS_DIR}/*.tar.gz")
  end

   def download_respaldo
    path="#{BACKUPS_DIR}/" + params[:archivo]
    send_file path , :disposition => 'inline'
  end

   def report_by_niveles
     #@niveles = Nivel.find(:all, :order => "descripcion")
     @niveles = Escuela.find(:all, :group => "nivel_descripcion", :conditions => ["estatu_id IS NOT NULL"])
   end

   ################################################################################################
   #    ACCIONES DEL MENU DE ESCUELAS
   #
   ################################################################################################

   def menu_escuela
     @user = User.find(params[:id])
     @escuela = @user.escuela if @user
     @diagnostico = Diagnostico.find_by_user_id(@user.id) if @user
     @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
     
   end

   def show_bitacora
      @user = User.find(params[:id]) 
      render :partial => "escuelas/bitacora", :layout => "only_jquery"
   end

   def show_diagnostico
      @escuela = Escuela.find(params[:id])
      @diagnostico = Diagnostico.find_by_escuela_id(@escuela.id) if @escuela
      if @diagnostico
        render :partial => "show_diagnostico", :layout => "only_jquery"
      else
        render :text => "<h1 style='color: red;' align='center'>No existe diagnóstico registrado</h1>"
      end
   end

   def menu_documentos_registro
     @escuela = Escuela.find(params[:id])
     render :partial => "menu_documentos_registro", :layout => "only_jquery"
   end

   def show_galeria
     @user = User.find(params[:id])
     @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? AND file_type = ?", @user.id, "image/jpeg"], :limit => 20) if @user
     unless @adjuntos.empty?
       render :partial => "galeria/galeria", :layout => "only_jquery"
     else
       render :text => "<h1 style='color: red;' align='center'>No existen archivos de imágenes</h1>"
     end
   end

   def menu_proyecto
     @escuela = Escuela.find(params[:id])
     @diagnostico = Diagnostico.find(params[:diagnostico])
     @proyecto = @diagnostico.proyecto
     render :partial => "menu_proyecto", :layout => "only_jquery"
   end

  

end
