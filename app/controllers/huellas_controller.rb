class HuellasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
  end

  def save
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @huella.update_attributes(params[:huella])
    @huella.diagnostico = Diagnostico.find(params[:diagnostico])

    @huella.tienen_equipos_desc = '' unless params[:huella][:tienen_equipos_desc]
    @huella.potab_agua_desc = '' unless params[:huella][:potab_agua_desc]
    @huella.servicios_comun_desc = '' unless params[:huella][:servicios_comun_desc]
    
    @huella.sanitarios_fugas = '' if params[:huella][:sanitarios_num].to_i < 1
    @huella.bebederos_fugas = '' if params[:huella][:bebederos_num].to_i < 1
    @huella.tomas_agua_fugas = '' if params[:huella][:tomas_agua_num].to_i < 1
    @huella.cisternas_fugas = '' if params[:huella][:cisternas_num].to_i < 1

    @huella.recip_residuos_solid_num = '' unless params[:huella][:recip_residuos_solid_num]
    @huella.cta_recip_org_inorg_num = '' unless params[:huella][:cta_recip_org_inorg_num]

    if @huella.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
