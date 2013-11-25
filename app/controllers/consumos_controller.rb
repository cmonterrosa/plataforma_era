class ConsumosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @consumo = @diagnostico.consumo || Consumo.new
    @s_establecimiento = selected(@consumo.establecimiento) if @consumo.establecimiento
    @s_cubierto = selected(@consumo.cubierto) if @consumo.cubierto
    @s_plato = selected(@consumo.plato) if @consumo.plato
    @s_vaso = selected(@consumo.vaso) if @consumo.vaso
    @s_enfermedad = multiple_selected(@consumo.enfermedads) if @consumo.enfermedads
  end

  def save
    @consumo = Consumo.find(params[:id]) if params[:id]
    @consumo ||= Consumo.new
    @consumo.update_attributes(params[:consumo])
    @consumo.diagnostico = Diagnostico.find(params[:diagnostico])

    @consumo.establecimiento_id = Establecimiento.find_by_clave(params[:consumo][:establecimiento_id]).id if params[:consumo][:establecimiento_id]
    @consumo.cubierto_id = Utensilio.find_by_clave(params[:consumo][:cubierto_id]).id if params[:consumo][:cubierto_id]
    @consumo.plato_id = Utensilio.find_by_clave(params[:consumo][:plato_id]).id if params[:consumo][:plato_id]
    @consumo.vaso_id = Utensilio.find_by_clave(params[:consumo][:vaso_id]).id if params[:consumo][:vaso_id]
    
    @consumo.problemas_salud_desc = '' unless params[:consumo][:problemas_salud_desc]
    @consumo.material_servir_alim_desc = '' unless params[:consumo][:material_servir_alim_desc]

    if params[:enfermedads]
      @enfermedads = []
      params[:enfermedads].each { |op| @enfermedads << Enfermedad.find_by_clave(op)  }
      @consumo.enfermedads = Enfermedad.find(@enfermedads)
    end
    @consumo.enfermedads.destroy if params[:consumo][:problemas_salud] == 'NO'
    @consumo.establecimiento_id = '' if params[:consumo][:tipo_establec] == 'NO'
    @consumo.cubierto_id = '' if params[:consumo][:material_servir_alim] == 'NO'
    @consumo.plato_id = '' if params[:consumo][:material_servir_alim] == 'NO'
    @consumo.vaso_id = '' if params[:consumo][:material_servir_alim] == 'NO'

    if @consumo.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
