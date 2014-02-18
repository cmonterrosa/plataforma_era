class DiagnosticosController < ApplicationController
  layout :set_layout
  before_filter :login_required
  
  def index
    @competencias = Competencia.find(:all)
    flash[:notice] = "Únicamente podrá capturar Eje 1 y 2"
    @eje1=true
    @eje2=true
    @eje3=true
    @eje4=true
    @eje5=false
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
    flash[:error] = "El reporte se encuentra en fase de construccion"
    redirect_to :controller => "diagnosticos"
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]

    # -- Diagnostico ---
    @competencia = @diagnostico.competencia if @diagnostico.competencia
    @s_csalud = multiple_selected(@competencia.csaluds) if @competencia.csaluds
    @s_cmambiente = multiple_selected(@competencia.cmambientes) if @competencia.cmambientes
    @s_pedagogica = multiple_selected(@competencia.pedagogicas) if @competencia.pedagogicas
    @s_tambiental = multiple_selected(@competencia.tambientals) if @competencia.tambientals
    @s_cactividad = multiple_selected(@competencia.cactividads) if @competencia.cactividads
    @s_saludma = multiple_selected(@competencia.saludmas) if @competencia.saludmas

    # -- Entorno ---
    @entorno = @diagnostico.entorno if @diagnostico.entorno
    @s_area_verde = multiple_selected(@entorno.areas_verdes) if @entorno.areas_verdes
    @s_actividad = multiple_selected(@entorno.actividads) if @entorno.actividads
    @s_cuidado_salud = multiple_selected(@entorno.cuidado_saluds) if @entorno.cuidado_saluds
    @s_sector_salud = multiple_selected(@entorno.sector_saluds) if @entorno.sector_saluds

    # -- Huella --
    @huella = @diagnostico.huella if @diagnostico.huella

    # -- Consumo --
    @consumo = @diagnostico.consumo if @diagnostico.consumo

    # -- Participcion --
    @participacion = @diagnostico.participacion if @diagnostico.participacion
  end
  
  private

  def set_layout
    (action_name == 'reporte')? 'reporte' : 'era'
  end

end