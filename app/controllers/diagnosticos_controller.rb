class DiagnosticosController < ApplicationController
  layout :set_layout
  before_filter :login_required
  
  def index
    if current_user.has_role?("adminplat") || current_user.has_role?("admin")
      flash[:notice] = "Bienvenido al menú administrativo"
      redirect_to :controller => "admin"
    end

    @escuela = Escuela.find_by_clave(current_user.login.upcase)
    unless @escuela.registro_completo
      flash[:notice] = "Para iniciar al diagnostico, es necesario primero concluir el registro de dátos básicos"
      redirect_to :controller => "registro"
    end

    @competencias = Competencia.find(:all)
    #flash[:notice] = "Únicamente podrá capturar Eje 1 y 2"
    @eje1=true
    @eje2=true
    @eje3=true
    @eje4=true
    @eje5=true
    @diagnostico = Diagnostico.find_by_escuela_id(Escuela.find_by_clave(current_user.login.upcase)) if Escuela.find_by_clave(current_user.login.upcase)
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

  def oficializar
    @diagnostico = Diagnostico.find(params[:id])
    @diagnostico.oficializado = true
    @diagnostico.fecha_oficializado = Time.now
    @escuela = Escuela.find(@diagnostico.escuela_id)
    @escuela.update_bitacora!("diag-conc", current_user)
    if @diagnostico.save
      flash[:notice] = "El diagnóstico fue oficializado correctamente"
    else
      flash[:notice] = "El diagnóstico no pudo oficializarse, vuelva a intentarlo"
    end
    redirect_to :action => "index"
  end
    
  def reporte
    #flash[:error] = "El reporte se encuentra en fase de construccion"
    #redirect_to :controller => "diagnosticos"
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]

    # -- Diagnostico ---
    #@competencia = @diagnostico.competencia if @diagnostico.competencia
    #@s_csalud = multiple_selected(@competencia.csaluds) if @competencia.csaluds
    #@s_cmambiente = multiple_selected(@competencia.cmambientes) if @competencia.cmambientes
    #@s_pedagogica = multiple_selected(@competencia.pedagogicas) if @competencia.pedagogicas
    #@s_tambiental = multiple_selected(@competencia.tambientals) if @competencia.tambientals
    #@s_cactividad = multiple_selected(@competencia.cactividads) if @competencia.cactividads
    #@s_saludma = multiple_selected(@competencia.saludmas) if @competencia.saludmas

    # -- Entorno ---
    #@entorno = @diagnostico.entorno if @diagnostico.entorno
    #@s_area_verde = multiple_selected(@entorno.areas_verdes) if @entorno.areas_verdes
    #@s_actividad = multiple_selected(@entorno.actividads) if @entorno.actividads
    #@s_cuidado_salud = multiple_selected(@entorno.cuidado_saluds) if @entorno.cuidado_saluds
    #@s_sector_salud = multiple_selected(@entorno.sector_saluds) if @entorno.sector_saluds

    # -- Huella --
    #@huella = @diagnostico.huella if @diagnostico.huella

    # -- Consumo --
    #@consumo = @diagnostico.consumo if @diagnostico.consumo

    # -- Participcion --
    #@participacion = @diagnostico.participacion if @diagnostico.participacion
  end
  
  private

  def set_layout
    (action_name == 'reporte')? 'reporte' : 'diagnostico'
  end

end