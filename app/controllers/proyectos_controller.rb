class ProyectosController < ApplicationController
  layout :set_layout

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
  end

  def edit
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
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

  def seccion_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @id_usados = Eje.find(:all, :select => "catalogo_eje_id, lineas_accion_id, indicadore_id", :conditions => ["proyecto_id = ?", @proyecto.id])
    unless @id_usados.empty?
#    @lineas = LineasAccion.find(:all, :conditions => ["id not in (#{convertir_array(@id_usados,'linea').join(',')})"])
#    @indicadores = Indicadore.find(:all, :conditions => ["id not in (#{convertir_array(@id_usados,'indicador').join(',')})"])
    @catalogo_ejes = CatalogoEje.find(:all, :conditions => ["id not in (#{convertir_array(@id_usados,'eje').join(',')})"] )
    else
#      @lineas = LineasAccion.find(:all)
#      @indicadores = Indicadore.find(:all)
      @catalogo_ejes = CatalogoEje.find(:all)
    end
  end

  def edit_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @lineas = LineasAccion.find(:all)
    @indicadores = Indicadore.find(:all)
    @catalogo_ejes = CatalogoEje.find(:all)
  end

  def proyect_to_pdf
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id)
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
  end

  private

  def convertir_array(array,field)
    arreglo =[]
    array.each do |a|
      arreglo << a.catalogo_eje_id if field =='eje'
      arreglo << a.lineas_accion_id if field =='linea'
      arreglo << a.indicadore_id if field =='indicador'
    end
    return arreglo
  end

  def set_layout
    (action_name == 'proyect_to_pdf')? 'reporte' : 'era2014'
  end

end
