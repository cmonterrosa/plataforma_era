class EjesController < ApplicationController
  def index
  end

  def save_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @eje ||= Eje.new

    @lineas_accion_id = LineasAccion.find_by_clave(params[:eje][:lineas_accion_id]).id if params[:eje][:lineas_accion_id]
    params[:eje][:lineas_accion_id] = @lineas_accion_id if  @lineas_accion_id

    @indicador_id = Indicadore.find_by_clave(params[:eje][:indicadore_id]).id if params[:eje][:indicadore_id]
    params[:eje][:indicadore_id] = @indicador_id if  @indicador_id

    @catalogo_eje_id = CatalogoEje.find_by_clave(params[:eje][:catalogo_eje_id]).id if params[:eje][:catalogo_eje_id]
    params[:eje][:catalogo_eje_id] = @catalogo_eje_id if  @catalogo_eje_id

    params[:eje][:proyecto_id] = params[:proyecto] if params[:proyecto]
    
    if @eje.update_attributes(params[:eje])
       redirect_to :controller => "proyectos", :action => "index"
    else
       flash[:error] = "No se pudo crear el eje a desarrollar"
    end
  end

end

