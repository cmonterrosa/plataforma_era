class CompetenciasController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save

  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new
  end

  def save
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @competencia.update_attributes(params[:competencia])
    @competencia.diagnostico = Diagnostico.find(params[:diagnostico])
    if @competencia.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
