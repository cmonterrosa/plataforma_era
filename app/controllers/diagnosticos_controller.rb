class DiagnosticosController < ApplicationController
  layout :set_layout
  before_filter :login_required
  
  def index
    @competencias = Competencia.find(:all)
  end

  def new_or_edit
    unless Diagnostico.find_by_escuela_id(Escuela.find_by_clave(current_user.login.upcase))
      @escuela = Escuela.find_by_clave(current_user.login.upcase)
      @diagnostico = Diagnostico.new(:escuela_id => @escuela.id, :user_id => current_user.id)
      if @diagnostico.save
        @escuela.update_bitacora!("diag-inic", current_user)
        flash[:notice] = "Bienvenido a la captura del diagnóstico"
      else
        flash[:error] = "No se pudo crear objeto, verifique"
      end
    end
    redirect_to :action => "index"
  end
    
  def reporte
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @competencia = @diagnostico.competencia if @diagnostico.competencia
    @entorno = @diagnostico.entorno if @diagnostico.entorno
    @huella = @diagnostico.huella if @diagnostico.huella
    @consumo = @diagnostico.consumo if @diagnostico.consumo
    @participacion = @diagnostico.participacion if @diagnostico.participacion
  end
  
  private

  def set_layout
    (action_name == 'reporte')? 'reporte' : 'era'
  end

end