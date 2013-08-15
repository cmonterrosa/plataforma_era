class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @escuela = Escuela.find_by_clave(@user.login.upcase) if @user.login
    if User.find_by_login(@user.login)
      flash[:error]  = "Escuela ya existe registrada"
      render :action => 'new'
    else
       @user.activated_at = Time.now
        if @escuela
            success = @user && @user.save
              if success && @user.errors.empty?
                redirect_back_or_default('/')
                  flash[:notice] = "ESCUELA #{@escuela.nombre} REGISTRADA"
              else
                flash[:error]  = "No se puedo crear la cuenta, verifique los datos."
                render :action => 'new'
              end
        else
            flash[:error]  = "No existe escuela con esa clave, intente de nuevo"
            render :action => 'new'
        end
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
end
