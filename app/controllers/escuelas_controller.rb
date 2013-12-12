class EscuelasController < ApplicationController
#  auto_complete_for :escuela, :clave
  before_filter :login_required

  def index
    @escuelas = Escuela.find(:all, :conditions => ['cct_zona = ? and clave LIKE ?', current_user.login.upcase, "%#{params[:search]}%"], :limit => 15)
  end
  
  def show
    @user ||= User.find_by_login(params[:id])
    @user ||= current_user
    @escuela ||= Escuela.find_by_clave(@user.login) if @user
    unless @escuela
      flash[:error] = "El usuario no corresponde a un centro escolar"
      redirect_to :action => "show_users", :controller => "admin"
    end
  end

  def show_fancy
    @user ||= User.find(params[:id])
    @user ||= current_user
    @escuela ||= Escuela.find_by_clave(@user.login) if @user
    return render(:partial => 'show', :layout => "only_jquery")
  end

  def show_diagnostico
    return render(:partial => 'show_diagnostico', :layout => "only_jquery")
  end

  def information_edit
    @user = current_user
  end

  def save_information
    @user = current_user
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Tus datos se actualizaron correctamente"
      redirect_to :controller => "home"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit'
    end
  end

end
