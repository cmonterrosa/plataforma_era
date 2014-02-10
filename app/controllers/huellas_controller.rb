class HuellasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
    @s_inorganicos = multiple_selected(@huella.inorganicos) if @huella.inorganicos
    @s_elimina_inorganicos = multiple_selected(@huella.elimina_inorganicos) if @huella.elimina_inorganicos
    @s_elimina_organicos = multiple_selected(@huella.elimina_organicos) if @huella.elimina_organicos
  end

  def save
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @huella.update_attributes(params[:huella])
    @huella.diagnostico = Diagnostico.find(params[:diagnostico])


    if params[:inorganicos]
      @inorganicos = []
      params[:inorganicos].each { |op| @inorganicos << Inorganico.find_by_clave(op)  }
      @huella.inorganicos = Inorganico.find(@inorganicos)
    end
    if params[:elimina_inorganicos]
      @elimina_inorganicos = []
      params[:elimina_inorganicos].each { |op| @elimina_inorganicos << EliminaInorganico.find_by_clave(op)  }
      @huella.elimina_inorganicos = EliminaInorganico.find(@elimina_inorganicos)
    end
    if params[:elimina_organicos]
      @elimina_organicos = []
      params[:elimina_organicos].each { |op| @elimina_organicos << EliminaOrganico.find_by_clave(op)  }
      @huella.elimina_organicos = EliminaOrganico.find(@elimina_organicos)
    end


    if @huella.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
