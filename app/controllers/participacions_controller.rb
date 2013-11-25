class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new

    @s_pcolectiva = selected(@participacion.pcolectiva) if @participacion.pcolectiva
    @s_acomunitaria = selected(@participacion.acomunitaria) if @participacion.acomunitaria
  end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @participacion.diagnostico = Diagnostico.find(params[:diagnostico])

    @participacion.pcolectiva_id = Pcolectiva.find_by_clave(params[:participacion][:pcolectiva_id]).id if params[:participacion][:pcolectiva_id]
    @participacion.acomunitaria_id = Acomunitaria.find_by_clave(params[:participacion][:acomunitaria_id]).id if params[:participacion][:acomunitaria_id]

    @participacion.pcolectiva_id = '' if params[:participacion][:esc_participa_proy] == 'NO'
    @participacion.acomunitaria_id = '' if params[:participacion][:familia_involucran_actividades] == 'NO'
    
    if @participacion.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "diagnosticos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      render :action => "new_or_edit"
    end
  end

end
