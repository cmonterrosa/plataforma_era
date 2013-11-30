# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout 'era'

  # render new.erb.html
  def new
    @user = User.new
  end

  def create
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
      redirect_back_or_default('/home/registro')
      flash[:notice] = "Has iniciado sesión"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Has cerrado sesión"
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
   # is_user_blocked=(User.find(params[:login]) ? User.find(params[:login]).blocked : nil
    #msj=(User.find(params[:login]) ? User.find(params[:login]).blocked : nil)? "Usuario ha sido bloqueado, comuníquese con el administrador en la siguiente dirección: #{SITE_EMAIL}" : "Nombre de usuario o contraseña incorrectas, si tiene alguna duda, puede enviar un correo electrónico a: #{SITE_EMAIL}"
    flash[:error] = "Nombre de usuario o contraseña incorrectas, si tiene alguna duda, puede enviar un correo electrónico a: #{SITE_EMAIL}"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
