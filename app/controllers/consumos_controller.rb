class ConsumosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @consumo = @diagnostico.consumo || Consumo.new
  end

  def save
    @consumo = Consumo.find(params[:id]) if params[:id]
    @consumo ||= Consumo.new
    @consumo.update_attributes(params[:consumo])
    @consumo.diagnostico = Diagnostico.find(params[:diagnostico])
    if @consumo.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
