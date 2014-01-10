require 'fastercsv'
class AdminController < ApplicationController
  #protect_from_forgery
  require_role [:directivo], :only => [:show_escuelas]
  #require_role [:admin]
  
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
    success = @user && @user.save
    if success && @user.errors.empty?
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
    @escuelas_registradas_en_plataforma = Escuela.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("esc-regis").id ])
    @escuelas_datos_basicos_capturados = Escuela.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("esc-datos").id ])
    @escuelas_diagnostico_iniciado = Escuela.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("diag-inic").id ])
    @total_escuelas_ingresadas = User.count(:id, :joins => "users, escuelas e", :conditions => "users.login=e.clave")
    @directivos_escolares_registrados =  Directivo.count(:id, :conditions => ["estatu_id = ?", Estatu.find_by_clave("dir-regis") ])
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
    @escuelas = User.find(:all, :select => "users.created_at as user_created_at, users.login, users.id as user_id, e.*", :joins => "users, escuelas e", :conditions => "users.login=e.clave")
    csv_string = FasterCSV.generate do |csv|
      csv << ["NOMBRE", "CCT_SECTOR", "CCT_ZONA", "ZONA_ESCOLAR", "CLAVE_ESCUELA", "DOMICILIO", "LOCALIDAD", "MUNICIPIO", "MODALIDAD", "FECHA_HORA_CAPTURA"]

      @escuelas.each do |i|
         csv << [i["nombre"], i["cct_sector"], i["cct_zona"], i["zona_escolar"], i["clave"], i["domicilio"], i["localidad"], i['municipio'], i['modalidad'], i['user_created_at']]
       end
    end
  send_data csv_string, type => "text/plain",
    :filename => "escuelas_ESyS_#{Time.now.strftime("%d-%m-%Y_%I%M_%p")}.csv",
    :disposition => "attachment"
  end
  
end
