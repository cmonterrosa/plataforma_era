class RegistroController < ApplicationController
  def index
    redirect_to :action => "new_or_edit"
  end

  def index
    @escuela = Escuela.new
  end
  
  def new_or_edit
    unless params[:escuela][:clave].size > 4 && @escuela = Escuela.find_by_clave(params[:escuela][:clave])
      flash[:error] = "No existe escuela"
      redirect_to :controller => "home"
    end
  end

  def save
    @escuela = Escuela.find_by_clave(params[:escuela][:clave])
    @escuela ||= Escuela.new(params[:escuela])
    @proyecto = @escuela.proyecto
    @proyecto ||= Proyecto.new(params[:proyecto])
    @escuela.proyecto = @proyecto
    if @escuela.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "home"
    else
      flash[:error] = "No se puedo guardar, verifique el registro"
      render :action => "new_or_edit"
    end
  end

  def show_info_escuela
    if params[:escuela_clave].size > 4
      @escuela = Escuela.find_by_clave(params[:escuela_clave])
      return render(:partial => 'list_by_user', :layout => false) if @escuela && request.xhr?
    end
  end

end
