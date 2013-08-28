class DcompetenciasController < ApplicationController
  layout 'era'

  def index
    new_or_edit
    render :action => 'new_or_edit'
  end

  def new_or_edit
    @reporte = Reporte.find(params[:id])
    @tipo_reporte = TipoReporte.find(@reporte.tipo_reporte)
    @escuela = Escuela.find(@tipo_reporte.escuela)
    @dcomptencias = @reporte.dcompetencia || Dcompetencia.new
 end

  def save
    begin
      @dcomptencias = Dcompetencia.find(params[:id])
      @dcomptencias.update_attributes!(params[:dcompetencia])
        flash[:notice]= "El registro fué actualizado"
        redirect_to new_or_edit_dcompetencia_path
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to tipo_reporte_path
    end
  end

end
