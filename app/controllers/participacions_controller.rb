class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
    @s_dcapacitadoras = multiple_selected(@participacion.dcapacitadoras)
    a=10
  end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @diagnostico = @participacion.diagnostico = Diagnostico.find(params[:diagnostico])

#    validador = verifica_evidencias(@diagnostico,5)
     validador="valido"

     #if validador["valido"]
     if validador == "valido"
      #@participacion.proy_escolares_ma_desc = '' unless params[:participacion][:proy_escolares_ma_desc]
      #@participacion.proy_escolares_salud_desc = '' unless params[:participacion][:proy_escolares_salud_desc]
      #@participacion.act_salud_ma_desc = '' unless params[:participacion][:act_salud_ma_desc]
      #@participacion.act_dep_gobierno_desc = '' unless params[:participacion][:act_dep_gobierno_desc]
    
      if @participacion.save

        ## Capacitadoras ##
        @capacitadoras = params[:capacitacion] if params[:capacitacion]
        @capacitadoras.each do |c|
            dc = Dcapacitadora.find_by_clave(c.last)
            capacitacion = CapacitacionPadre.find_by_dcapacitadora_id(dc.id) if dc
            capacitacion ||= CapacitacionPadre.new
            capacitacion.participacion_id  ||= @participacion.id
            capacitacion.dcapacitadora_id ||= dc.id if dc
            capacitacion.numero_capacitaciones =(params[:capacitadora]["#{dc.clave}"]) ?  params[:capacitadora]["#{dc.clave}"] : nil
            (capacitacion.numero_capacitaciones) ? capacitacion.save : nil
        end


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
