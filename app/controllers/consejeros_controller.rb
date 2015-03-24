class ConsejerosController < ApplicationController
  require_role [:coordinador, :consejero, :equipotecnico], :except => [:index, :signup, :new]

  def menu
    @user = current_user
  end


  def index
    redirect_to :action => "menu" if current_user
  end

  def signup
  end

  ### Funciones por defecto para crear usuarios  ####
  #  include AuthenticatedSystem

  def new
    @user = User.new
    @roles = Role.find(:all, :conditions => ["name in (?)", ["consejero", "equipotecnico"]])
    #redirect_to :action => "periodo_expirado", :controller => "home"
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    @user ||= User.new
    @saving=false
    @roles = Role.find(:all, :conditions => ["name in (?)", ["consejero", "equipotecnico"]])
    has_permission = params[:clave] && params[:clave][:clave_seguridad] == CLAVE_SEGURIDAD
    if has_permission
       success = @user && @user.save
          if success && @user.errors.empty?
            @role = Role.find(params[:role][:id]) if params[:role][:id]
            @user.roles << @role if @role
            if @role && @user.save
              flash[:notice] = "USUARIO REGISTRADO CON PERFIL DE: #{@role.descripcion}"
              redirect_back_or_default('/consejeros/index')
            else
              flash[:error] = "NO SE PUDO REGISTRAR USUARIO"
              render :action => 'new'
            end
          else
            flash[:error]  = "No se puedo crear la cuenta, verifique los datos."
             render :action => 'new'
          end
    else
         flash[:error]  = "Clave de seguridad inválida, vuelva a escribirla"
          render :action => 'new'
    end
 end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def forgot
  if request.post?
    user = User.find_by_email(params[:user][:email])

    respond_to do |format|
        if user
          user.create_reset_code
          #UserMailer.deliver_forgot(user) #sends the email
          UserMailer.deliver_reset_notification(user) if user.recently_reset? && user.email_valid?
          flash[:notice] = "Código de recuperación enviado a: #{user.email}"
          format.html { redirect_to login_path }
          format.xml { render :xml => user.email, :status => :created }
        else
          flash[:error] = "#{params[:user][:email]} no existe en el sistema"
          format.html { redirect_to login_path }
          format.xml { render :xml => user.email, :status => :unprocessable_entity }
        end
      end
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Contraseña cambiada correctamente para: #{@user.email}"
        redirect_to root_url
      else
        render :action => :reset
      end
    end
  end

  ##################################################
  #   Funciones para crear sesiones
  #
  ##################################################

  def new_session
    @user = User.new
  end

  def create_session
    logout_keeping_session!
    login = (params[:user][:login]) ? params[:user][:login].downcase : nil
    password = (params[:user][:password])
    user = User.authenticate(login, password)
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/consejeros/menu')
      flash[:notice] = "Has iniciado sesión"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy_session
    logout_killing_session!
    flash[:notice] = "Has cerrado sesión"
    redirect_back_or_default('/')
  end
end
