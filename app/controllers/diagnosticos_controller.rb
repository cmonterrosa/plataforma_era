class DiagnosticosController < ApplicationController
  layout :set_layout
  before_filter :login_required
  
  def index
    if current_user.has_role?("adminplat") || current_user.has_role?("admin")
      flash[:notice] = "Bienvenido al menú administrativo"
      redirect_to :controller => "admin"
    end

    @escuela= Escuela.find(params[:id]) if params[:id]
    @escuela ||= Escuela.find_by_clave(current_user.login.upcase)
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
#    @competencia = @diagnostico.competencia if @diagnostico.competencia
#    @s_csalud = multiple_selected(@competencia.csaluds) if @competencia.csaluds
#    @s_cmambiente = multiple_selected(@competencia.cmambientes) if @competencia.cmambientes
#    @s_pedagogica = multiple_selected(@competencia.pedagogicas) if @competencia.pedagogicas
#    @s_tambiental = multiple_selected(@competencia.tambientals) if @competencia.tambientals
#    @s_cactividad = multiple_selected(@competencia.cactividads) if @competencia.cactividads
#    @s_saludma = multiple_selected(@competencia.saludmas) if @competencia.saludmas

    # -- Entorno ---
#    @entorno = @diagnostico.entorno if @diagnostico.entorno
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

  def reporte_completo
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    # -- Diagnostico ---
    @competencia = @diagnostico.competencia if @diagnostico.competencia
      # -- Operaciones --
      @cp1 = (((@competencia.docentes_capacitados_sma.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p1.to_f).round(3)
      @cp2 = (((@competencia.docentes_aplican_conocimientos.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p2.to_f).round(3)
      @cp3 = (((@competencia.docentes_involucran_actividades.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p3.to_f).round(3)
      @cp4 = (((@competencia.alumnos_capacitados_docentes.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p4.to_f).round(3)
      @cp5 = (((@competencia.alumnos_capacitados_instituciones.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p5.to_f).round(3)

      @c_maxptos = (($competencia_p1.to_f + $competencia_p2.to_f + $competencia_p3.to_f + $competencia_p5.to_f + $competencia_p5.to_f)*100).round(3)
      @c_totalptos = (@cp1.to_f + @cp2.to_f + @cp3.to_f + @cp4.to_f + @cp5.to_f).round(3)
      @c_porcentaje = ((@c_totalptos.to_f * 100) / @c_maxptos.to_f).round(3)

    # -- Entorno ---
    @entorno = @diagnostico.entorno if @diagnostico.entorno
      # -- Operaciones --
      ((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round > 25 ? @ep2 = ptos_superficie(25) : @ep2 = ptos_superficie(((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round)
      
      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      if @diagnostico.escuela.nivel_descripcion == "BACHILLERATO"
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
        @ep6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
      else
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
        @ep6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
      end
      
      @e_maxptos = (($entorno_p2.to_f + $entorno_p6.to_f)*100).round(3)
      @e_totalptos = (@ep2.to_f + @ep5.to_f).round(3)
      @e_porcentaje = ((@e_totalptos.to_f * 100) / @e_maxptos.to_f).round(3)

    # -- Huella ---
    @huella = @diagnostico.huella if @diagnostico.huella
      # -- Operaciones --
      @hp1 = (((@huella.capacitacion_ahorro_energia.to_f / 2 ) * 100) * $huella_p1.to_f).round(3)

      @huella.consumo_anterior > @huella.consumo_actual ? @hp2 = $huella_p2 * 100 : @hp2 = 0
        
      @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
      @hp3 = (((@huella.focos_ahorradores.to_f / @huella.total_focos.to_f ) * 100) * $huella_p3.to_f).round(3)

      @s_aguas = selected(@huella.servicio_agua) if @huella.servicio_agua
      @huella.red_publica_agua == "SI" ? @hp4 = $huella_p4 * 100 : @hp4 = 0
      @hp5 = (((@huella.mantto_inst.to_f / 2 ) * 100) * $huella_p5.to_f).round(3)

      @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
      @huella.recip_residuos_solid == "SI" ? @hp6 = $huella_p6 * 100 : @hp6 = 0

      @huella.sep_residuos_org_inorg == "SI" ? @hp7 = $huella_p7 * 100 : @hp7 = 0

      @huella.elabora_compostas == "SI" ? @hp8 = $huella_p8 * 100 : @hp8 = 0
      
      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      (@s_inorganicos.size == 1 and @huella.inorganicos[0]['clave'] == "NING") ? @hp9 = 0 : @hp9 = ptos_inorganicos(@s_inorganicos.size)

      @h_maxptos = (($huella_p1.to_f + $huella_p2.to_f + $huella_p3.to_f + $huella_p4.to_f + $huella_p5.to_f + $huella_p6.to_f + $huella_p7.to_f + $huella_p8.to_f + $huella_p9.to_f)*100).round(3)
      @h_totalptos = (@hp1.to_f + @hp2.to_f + @hp3.to_f + @hp4.to_f + @hp5.to_f + @hp6.to_f + @hp7.to_f + @hp8.to_f + @hp9.to_f).round(3)
      @h_porcentaje = ((@h_totalptos.to_f * 100) / @h_maxptos.to_f).round(3)
  end
  
  private

  def set_layout
    (action_name == 'reporte_completo')? 'reporte' : 'diagnostico'
  end

end