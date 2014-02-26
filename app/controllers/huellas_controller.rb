class HuellasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
    @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
    @s_aguas = selected(@huella.servicio_agua) if @huella.servicio_agua
    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
    @ahorradores = Array.new
    @ahorradores << (@huella.focos_ahorradores.to_i) if @huella.focos_ahorradores
    @focos = 0..99
  end

  def save
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @huella.update_attributes(params[:huella])
    @diagnostico = @huella.diagnostico = Diagnostico.find(params[:diagnostico])

    validador = verifica_evidencias(@diagnostico,3)

    if validador["valido"]
      
      if (params[:huella][:red_publica_agua] == 'SI')
        @huella.servicio_agua_id = ''    
      else
        @huella.servicio_agua_id = ServicioAgua.find_by_clave(params[:huella][:servicio_agua_id]).id if params[:huella][:servicio_agua_id]
      end
      
      if (params[:huella][:energia_electrica_id] == 'SUOP')
        @huella.energia_electrica_id = '' 
      else
        @huella.energia_electrica_id = EnergiaElectrica.find_by_clave(params[:huella][:energia_electrica_id]).id if params[:huella][:energia_electrica_id]
      end

      if params[:inorganicos]
        @inorganicos = []
        params[:inorganicos].each { |op| @inorganicos << Inorganico.find_by_clave(op)  }
        @huella.inorganicos = Inorganico.find(@inorganicos)
      else
        @huella.inorganicos.delete_all
      end
    
      if params[:elimina_residuos] and params[:huella][:recip_residuos_solid] == 'NO'
        @elimina_residuos = []
        params[:elimina_residuos].each { |op| @elimina_residuos << EliminaResiduo.find_by_clave(op)  }
        @huella.elimina_residuos = EliminaResiduo.find(@elimina_residuos)
      else
        @huella.elimina_residuos.delete_all if @huella.elimina_residuos
      end
      
      if (params[:huella][:energia_electrica_id] != "SUOP")
        @huella.consumo_anterior = ""
        @huella.consumo_actual = ""
      end

      if @huella.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
        @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
#        @s_elimina_inorganicos = multiple_selected_id(@huella.elimina_inorganicos) if @huella.elimina_inorganicos
#        @s_elimina_organicos = multiple_selected_id(@huella.elimina_organicos) if @huella.elimina_organicos
        @ahorradores = Array.new
        @ahorradores << (@huella.focos_ahorradores.to_i) if @huella.focos_ahorradores
        @focos = 0..99
        flash[:error] = "No se pudo guardar, verifique los datos"
        flash[:evidencias] = @huella.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      @ahorradores = Array.new
      @ahorradores << (@huella.focos_ahorradores.to_i) if @huella.focos_ahorradores
      @focos = 0..99
      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
#      @s_elimina_inorganicos = multiple_selected_id(@huella.elimina_inorganicos) if @huella.elimina_inorganicos
#      @s_elimina_organicos = multiple_selected_id(@huella.elimina_organicos) if @huella.elimina_organicos
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
