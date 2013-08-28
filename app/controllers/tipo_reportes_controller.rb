class TipoReportesController < ApplicationController
  layout 'era'
  
  def tipo_reportes
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
     @tipo_reporte = TipoReporte.find(:all, :order => 'prioridad')
  end

  def show
    @tipo_reporte = TipoReporte.find(params[:id])
  end

  def new
    @tipo_reporte = TipoReporte.new
  end

  def create
    begin
      @tipo_reporte = TipoReporte.new(params[:tipo_reporte])
      @tipo_reporte.save!
        flash[:notice]= "Registro creado satisfactoriamente"
        redirect_to tipo_reportes_path
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to new_tipo_reporte_path
    end
  end

  def edit
    @tipo_reporte = TipoReporte.find(params[:id])
  end

  def update
    begin
      @tipo_reporte = TipoReporte.find(params[:id])
      @tipo_reporte.update_attributes!(params[:tipo_reporte])
        flash[:notice]= "El registro fué actualizado"
        redirect_to tipo_reportes_path
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to edit_tipo_reporte_path
    end
  end

  def destroy
    begin
      registro = TipoReporte.find(:first, :conditions => ["id = ?", params[:id]])
      registro.destroy
    rescue ActiveRecord::StatementInvalid => error
        flash[:notice] = "No se puede eliminar el registro #{registro.nombre}, existen relaciones con otras tablas"
    end
    redirect_to tipo_reportes_path
  end

end
