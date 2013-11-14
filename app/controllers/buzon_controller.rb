class BuzonController < ApplicationController
  require_role [:escuela]
  
  def index
    @comentarios = Comentario.find(:all, :conditions => ["user_id = ?", current_user])
  end

  def new
    @comentario = Comentario.new
  end

  def save
    @comentario = Comentario.new(params[:comentario])
    @comentario.user_id = current_user if current_user
    if @comentario.save
      flash[:notice] = "Comentario enviado correctamente"
      redirect_to :action => "index", :controller => "home"
    else
      flash[:error] = "No se pudo enviar comentario, intentelo nuevamente"
      render :action => "new"
    end
  end

end
