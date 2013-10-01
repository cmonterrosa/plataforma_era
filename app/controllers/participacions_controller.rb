class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
  end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @participacion.diagnostico = Diagnostico.find(params[:diagnostico])
    if @participacion.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
