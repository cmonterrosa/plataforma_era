class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
    @s_dcapacitadoras = multiple_selected(@participacion.dcapacitadoras)
  end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @diagnostico = @participacion.diagnostico = Diagnostico.find(params[:diagnostico])

    validador = verifica_evidencias(@diagnostico,5)

    if validador["valido"]
      @participacion.proy_escolares_ma_desc = '' unless params[:participacion][:proy_escolares_ma_desc]
      @participacion.proy_escolares_salud_desc = '' unless params[:participacion][:proy_escolares_salud_desc]
      @participacion.act_salud_ma_desc = '' unless params[:participacion][:act_salud_ma_desc]
      @participacion.act_dep_gobierno_desc = '' unless params[:participacion][:act_dep_gobierno_desc]
    
      if @participacion.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:evidencias] = @participacion.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
