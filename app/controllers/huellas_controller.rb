class HuellasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @s_elimina_inorganicos = multiple_selected_id(@huella.elimina_inorganicos) if @huella.elimina_inorganicos
    @s_elimina_organicos = multiple_selected_id(@huella.elimina_organicos) if @huella.elimina_organicos
  end

  def save
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @huella.update_attributes(params[:huella])
    @diagnostico = @huella.diagnostico = Diagnostico.find(params[:diagnostico])

    validador = verifica_evidencias(@diagnostico,3)

    if validador["valido"]
      @huella.servicio_agua_id = '' if params[:huella][:red_publica_agua] == 'SI'
    
      if params[:inorganicos]
        @inorganicos = []
        params[:inorganicos].each { |op| @inorganicos << Inorganico.find_by_clave(op)  }
        @huella.inorganicos = Inorganico.find(@inorganicos)
      else
        @huella.inorganicos.delete_all
      end

      if params[:elimina_inorganicos]
        @elimina_inorganicos = []
        params[:elimina_inorganicos].each { |op| @elimina_inorganicos << EliminaInorganico.find_by_clave(op)  }
        @huella.elimina_inorganicos = EliminaInorganico.find(@elimina_inorganicos)
      else
        @huella.elimina_inorganicos.delete_all
      end
    
      if params[:elimina_organicos]
        @elimina_organicos = []
        params[:elimina_organicos].each { |op| @elimina_organicos << EliminaOrganico.find_by_clave(op)  }
        @huella.elimina_organicos = EliminaOrganico.find(@elimina_organicos)
      else
        @huella.elimina_organicos.delete_all
      end
    
      if @huella.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:error] = "No se pudo guardar, verifique los datos"
        render :action => "new_or_edit"
      end
    else
      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      @s_elimina_inorganicos = multiple_selected_id(@huella.elimina_inorganicos) if @huella.elimina_inorganicos
      @s_elimina_organicos = multiple_selected_id(@huella.elimina_organicos) if @huella.elimina_organicos
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

end
