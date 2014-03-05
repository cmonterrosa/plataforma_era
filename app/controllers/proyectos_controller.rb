class ProyectosController < ApplicationController
  before_filter :login_required
#  skip_before_filter :verify_authenticity_token, :only => [:save_first_section, :second_section_proyect]

  def index
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id)
    unless @diagnostico
      flash[:notice] = "Para iniciar la captura del proyecto, es necesario concluir la etapa de diagnóstico"
      redirect_to :action => "index", :controller => "diagnosticos"
    end
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
    @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
  end

  def get_contenido_ejes
    @eje = Eje.new
    @catalogo_ejes = CatalogoEje.find_by_clave( params[:eje_catalogo_eje_id]) if params[:eje_catalogo_eje_id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    #@lineas = LineasAccion.find_by_catalogo_eje_id(@catalogo_ejes)
    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )
    render :partial => "contenido_eje", :layout => "only_jquery"
  end

  def new_proyecto
    @proyecto = Proyecto.create(:diagnostico_id => Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
    if @proyecto
      redirect_to :action => "new_or_edit", :escuela_id => params[:escuela_id]
    else
      flash[:error] = "No se pudo iniciar el proyecto"
    end
  end

  def new_or_edit
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
    a=0
  end

  def edit
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
    a=0
  end

  def save
    @proyecto = Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto])
      redirect_to :action => "index"
    else
      flash[:error] = "No se pudo guardar el proyecto"
    end
  end

  def save_proyecto
    @proyecto = Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto])
      redirect_to :action => "seccion_eje"
    else
      flash[:error] = "No se pudo crear el proyecto"
    end
  end
#  def save_proyecto
#    @proyecto = Proyecto.find(params[:id])
#    if @proyecto.update_attributes(params[:proyecto])
#      @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
#      @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
#      @lineas = LineasAccion.find(:all)
#      @indicadores = Indicadore.find(:all)
#      @catalogo_ejes = CatalogoEje.find(:all)
#      render :partial => "seccion_eje"
#    else
#      flash[:error] = "No se pudo crear el proyecto"
#    end
#  end

  def seccion_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @lineas = LineasAccion.find(:all)
    @indicadores = Indicadore.find(:all)
    @catalogo_ejes = CatalogoEje.find(:all)
  end

  def edit_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @lineas = LineasAccion.find(:all)
    @indicadores = Indicadore.find(:all)
    @catalogo_ejes = CatalogoEje.find(:all)
  end

  def second_section_proyect
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @lineas = LineasAccion.find(:all, :conditions => [" num_eje = ?", @proyecto.eje.clave])
    @indicadores = Indicadore.find(:all, :conditions => [" num_eje = ?", @proyecto.eje.clave])
  end

  def save_second_section
    @proyecto = Proyecto.find(params[:proyecto_id])
#    @eje = Eje.find(@proyecto.eje).id if @proyecto

    @lineas_accion_id = LineasAccion.find_by_clave(params[:eje][:lineas_accion_id]).id if params[:eje][:lineas_accion_id]
    params[:eje][:lineas_accion_id] = @lineas_accion_id if  @lineas_accion_id

    @indicador_id = Indicadore.find_by_clave(params[:eje][:indicadore_id]).id if params[:eje][:indicadore_id]
    params[:eje][:indicadore_id] = @indicador_id if  @indicador_id

    if @proyecto.eje.update_attributes(params[:eje])
      redirect_to :action => "new_or_edit"
    else
      redirect_to :action => "second_section_proyect"
    end
  end
end
#  @diagnostico = Diagnostico.find(params[:id]) if params[:id]