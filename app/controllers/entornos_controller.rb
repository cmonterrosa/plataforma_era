class EntornosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @entorno = @diagnostico.entorno || Entorno.new
    @s_area_verde = multiple_selected(@entorno.areas_verdes) if @entorno.areas_verdes
    @s_actividad = multiple_selected(@entorno.actividads) if @entorno.actividads
    @s_cuidado_salud = multiple_selected(@entorno.cuidado_saluds) if @entorno.cuidado_saluds
    @s_sector_salud = multiple_selected(@entorno.sector_saluds) if @entorno.sector_saluds
  end

  def save
    @entorno = Entorno.find(params[:id]) if params[:id]
    @entorno ||= Entorno.new
    @entorno.update_attributes(params[:entorno])
    @entorno.diagnostico = Diagnostico.find(params[:diagnostico])

    @entorno.areas_verdes_esc_desc = '' unless params[:entorno][:areas_verdes_esc_desc]
    @entorno.cuidado_preserv_reforest_desc = '' unless params[:entorno][:cuidado_preserv_reforest_desc]
    @entorno.prom_cuidado_salud_desc = '' unless params[:entorno][:prom_cuidado_salud_desc]
    @entorno.part_sector_salud_desc = '' unless params[:entorno][:part_sector_salud_desc]

    if params[:areas_verdes]
      @areas_verdes = []
      params[:areas_verdes].each { |op| @areas_verdes << AreasVerde.find_by_clave(op)  }
      @entorno.areas_verdes = AreasVerde.find(@areas_verdes)
    end
    @entorno.areas_verdes.destroy if params[:entorno][:exist_areas_verde] == 'NO'

    if params[:actividads]
      @actividads = []
      params[:actividads].each { |op| @actividads << Actividad.find_by_clave(op)  }
      @entorno.actividads = Actividad.find(@actividads)
    end
    @entorno.actividads.destroy if params[:entorno][:act_areas_verde] == 'NO'

    if params[:cuidado_saluds]
      @cuidado_saluds = []
      params[:cuidado_saluds].each { |op| @cuidado_saluds << CuidadoSalud.find_by_clave(op)  }
      @entorno.cuidado_saluds = CuidadoSalud.find(@cuidado_saluds)
    end
    @entorno.cuidado_saluds.destroy if params[:entorno][:prom_cuidado_salud] == 'NO'
    
    if params[:sector_saluds]
      @sector_saluds = []
      params[:sector_saluds].each { |op| @sector_saluds << SectorSalud.find_by_clave(op)  }
      @entorno.sector_saluds = SectorSalud.find(@sector_saluds)
    end
    @entorno.sector_saluds.destroy if params[:entorno][:part_sector_salud] == 'NO'

    if @entorno.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end
  
end
