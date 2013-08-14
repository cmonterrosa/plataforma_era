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
    @proyecto = @escuela.proyecto if @escuela
  end

  def save
    @escuela = Escuela.find_by_clave(params[:clave]) if params[:clave]
    @escuela ||= Escuela.new
    @escuela.update_attributes(params[:escuela])
    @escuela.categoria_escuela = CategoriaEscuela.find(params[:escuela][:categoria_escuela_id]) if params[:escuela][:categoria_escuela_id]
    @proyecto = (@escuela.proyecto) ? @escuela.proyecto : Proyecto.new
    @proyecto.update_attributes(params[:proyecto])
    @proyecto.clave = @escuela.clave if @escuela.clave
    @escuela.proyecto = @proyecto
    if @escuela.save && @proyecto.save
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
