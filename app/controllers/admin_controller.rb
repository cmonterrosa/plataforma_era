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
    @user = User.find(params[:id])
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
    @usuarios = User.find(:all, :order => "created_at")
  end

  def show_escuelas
    @escuelas = Escuela.find(:all, :conditions => ["cct_zona = ?", current_user.login.upcase], :order => "nombre")
   # render :text => @escuelas.collect{|x|x.inspect}
  end

  def show_results
    @usuarios ||= User.find(:all, :select => "u.*", :joins => "u, escuelas escuelas",:conditions => ["escuelas.id=u.escuela_id AND escuelas.clave = ?", params[:clave_escuela]]) if params[:clave_escuela].size > 0
    @usuarios ||= User.find(:all, :select => "u.*", :joins => "u, escuelas escuelas",:conditions => ["escuelas.id=u.escuela_id AND escuelas.nombre like ?", "#{params[:nombre_escuela]}%"]) if params[:nombre_escuela].size > 0
    @usuarios ||= User.find(:all, :select => "u.*", :joins => "u, escuelas escuelas",:conditions => ["escuelas.id=u.escuela_id AND escuelas.estatu_id = ?", params[:estatus_escuela]]) if params[:estatus_escuela].size > 0
  end

   def block_user
   if @user = User.find(params[:id])
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

  ############## COMENTARIOS #####################

  def show_comentarios
    @comentarios = Comentario.find(:all)
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
  end

end
