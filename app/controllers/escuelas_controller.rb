class EscuelasController < ApplicationController
  def show
    @user ||= User.find(params[:id])
    @user ||= current_user
    @escuela ||= Escuela.find_by_clave(@user.login) if @user
    unless @escuela
      flash[:error] = "El usuario no corresponde a un centro escolar"
      redirect_to :action => "show_users", :controller => "admin"
    end
  end

end
