class HuellasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
    @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @s_servicio_aguas = multiple_selected_id(@huella.servicio_aguas) if @huella.servicio_aguas
    @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
    @focos = 0..499
  end

  def save
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @huella.update_attributes(params[:huella])
    @diagnostico = @huella.diagnostico = Diagnostico.find(params[:diagnostico])

    if params[:inorganicos]
      @inorganicos = []
      params[:inorganicos].each { |op| @inorganicos << Inorganico.find_by_clave(op)  }
      @huella.inorganicos = Inorganico.find(@inorganicos)
    else
      @huella.inorganicos.delete_all
    end

    validador = verifica_evidencias(@diagnostico,3)

    if validador["valido"]
      
#      if (["NING", "SECC"].include?(params[:huella][:energia_electrica_id]))
#        @huella.energia_electrica_id = ''
#      else
        @huella.energia_electrica_id = EnergiaElectrica.find_by_clave(params[:huella][:energia_electrica_id]).id if params[:huella][:energia_electrica_id]
#      end
      @huella.total_focos = @huella.focos_ahorradores.to_i + @huella.focos_incandescentes.to_i

      if params[:servicio_aguas]
        @servicio_aguas = []
        params[:servicio_aguas].each { |op| @servicio_aguas << ServicioAgua.find_by_clave(op)  }
        @huella.servicio_aguas = ServicioAgua.find(@servicio_aguas)
      else
        @huella.servicio_aguas.delete_all
      end
       
      if params[:elimina_residuos]
        @elimina_residuos = []
        params[:elimina_residuos].each { |op| @elimina_residuos << EliminaResiduo.find_by_clave(op)  }
        @huella.elimina_residuos = EliminaResiduo.find(@elimina_residuos)
      else
        @huella.elimina_residuos.delete_all if @huella.elimina_residuos
      end
      
      unless (["NING", "SECC"].include?(params[:huella][:energia_electrica_id]))
        @huella.consumo_anterior = 0
        @huella.consumo_actual = 0
      end

      if @huella.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
        @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
        @s_servicio_aguas = multiple_selected_id(@huella.servicio_aguas) if @huella.servicio_aguas
        @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
        @focos = 0..499
        
        flash[:error] = "No se pudo guardar, verifique los datos"
        flash[:evidencias] = @huella.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      @s_servicio_aguas = multiple_selected_id(@huella.servicio_aguas) if @huella.servicio_aguas
      @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
      @focos = 0..499
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
