class DiagnosticosController < ApplicationController
  layout :set_layout
  #before_filter :login_required, :except => [:reporte_completo, :set_layout]
#  before_filter :no_disponible
  
  def index
    if current_user.has_role?("adminplat") || current_user.has_role?("admin")
      flash[:notice] = "Bienvenido al menú administrativo"
      redirect_to :controller => "admin"
    end

    @escuela= Escuela.find(params[:id]) if params[:id]
    @escuela ||= Escuela.find_by_clave(current_user.login.upcase)
    unless @escuela.registro_completo
      flash[:error] = "Para iniciar al diagnostico, es necesario primero concluir el registro de dátos básicos"
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
    diagnostico = Evaluacion.new(:diagnostico => @diagnostico)

    # ----- COMPETENCIA -----
    @competencia = @diagnostico.competencia if @diagnostico.competencia
    @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
    @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados

    @cp1 = diagnostico.puntaje_eje1_p1
    @cp2 = diagnostico.puntaje_eje1_p2
    @cp3 = diagnostico.puntaje_eje1_p3
    @cp4 = diagnostico.puntaje_eje1_p4
    @cp5 = diagnostico.puntaje_eje1_p5
    
    @c_maxptos = (($competencia_p1.to_f + $competencia_p2.to_f + $competencia_p3.to_f + $competencia_p5.to_f + $competencia_p5.to_f)*100).round(3)
    @c_totalptos = (@cp1.to_f + @cp2.to_f + @cp3.to_f + @cp4.to_f + @cp5.to_f).round(3)
    @c_porcentaje = @c_totalptos.to_f > 0 ? ((@c_totalptos.to_f * 100) / @c_maxptos.to_f).round(3) : 0

    # ----- ENTORNO -----
    @entorno = @diagnostico.entorno if @diagnostico.entorno
    @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
    @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
#    @escuela = Escuela.find_by_clave(current_user.login)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
    end
    @ep2 = diagnostico.puntaje_eje2_p2
    @ep3 = diagnostico.puntaje_eje2_p3
    @ep5 = diagnostico.puntaje_eje2_p5

    @e_maxptos = (($entorno_p2.to_f + $entorno_p3.to_f + $entorno_p5.to_f)*100).round(3)
    @e_totalptos = (@ep2.to_f + @ep3.to_f + @ep5.to_f).round(3)
    @e_porcentaje = @e_totalptos.to_f > 0 ? ((@e_totalptos.to_f * 100) / @e_maxptos.to_f).round(3) : 0

    # -- Huella ---
    @huella = @diagnostico.huella if @diagnostico.huella
    @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @s_servicio_aguas = multiple_selected_id(@huella.servicio_aguas) if @huella.servicio_aguas
    @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
    @focos = 0..499
    @hp1= diagnostico.puntaje_eje3_p1
    @hp3= diagnostico.puntaje_eje3_p3
    @hp5= diagnostico.puntaje_eje3_p5
    @hp7= diagnostico.puntaje_eje3_p7
    @hp8= diagnostico.puntaje_eje3_p8
    @hp9= diagnostico.puntaje_eje3_p9

    @h_maxptos = (($huella_p1.to_f + $huella_p3.to_f + $huella_p5.to_f + $huella_p7.to_f + $huella_p8.to_f + $huella_p9.to_f)*100).round(3)
    @h_totalptos = (@hp1.to_f + @hp3.to_f + @hp5.to_f + @hp7.to_f + @hp8.to_f + @hp9.to_f).round(3)
    @h_porcentaje = @h_totalptos.to_f > 0 ? ((@h_totalptos.to_f * 100) / @h_maxptos.to_f).round(3) : 0

    # -- Consumos --
    @consumo = @diagnostico.consumo if @diagnostico.consumo
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
    else
      @establecimientos = Establecimiento.find(:all)
    end
    @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
    @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
    @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
    @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
    @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
    @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
    @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
    @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
    @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
    @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
    @cop2= diagnostico.puntaje_eje4_p2
    @cop3= diagnostico.puntaje_eje4_p3
    @cop4= diagnostico.puntaje_eje4_p4
    @cop5= diagnostico.puntaje_eje4_p5
    @cop6= diagnostico.puntaje_eje4_p6
    @cop7= diagnostico.puntaje_eje4_p7
    @cop8= diagnostico.puntaje_eje4_p8

    @co_maxptos = (($consumo_p2.to_f + $consumo_p3.to_f + ($consumo_p4.to_f * 3) + ($consumo_p5.to_f * 4) + $consumo_p6.to_f + $consumo_p7.to_f + $consumo_p8.to_f)*100 ).round(3)
    @co_totalptos = (@cop2.to_f + @cop3.to_f + @cop4.to_f + @cop5.to_f + @cop6.to_f + @cop7.to_f + @cop8.to_f).round(3)
    @co_porcentaje = @co_totalptos.to_f > 0 ? ((@co_totalptos.to_f * 100) / @co_maxptos.to_f).round(3) : 0

    # -- Participación --
    @participacion = @diagnostico.participacion if @diagnostico.participacion
    @s_pdcapacitadoras = multiple_selected_dcapacitadora(@participacion.capacitacion_padres) if  @participacion.capacitacion_padres
    @s_proyectos_ma =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'MEDIOAMBIENTE'])
    @proyectos_seleccionados_ambiente = ( @s_proyectos_ma.empty?)? 0: @s_proyectos_ma.size
    @s_proyectos_salud =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'SALUD'])
    @proyectos_seleccionados_salud = ( @s_proyectos_salud.empty?)? 0: @s_proyectos_salud.size
    @s_proyectos_dependencias =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'DEPENDENCIAS'])
    @proyectos_seleccionados_dependencias = ( @s_proyectos_dependencias.empty?)? 0: @s_proyectos_dependencias.size
#    @pp1 = diagnostico.puntaje_eje5_p1
    @pp2 = diagnostico.puntaje_eje5_p2
    @pp3 = diagnostico.puntaje_eje5_p3
    @pp4 = diagnostico.puntaje_eje5_p4
    @pp5 = diagnostico.puntaje_eje5_p5
    @pp6 = diagnostico.puntaje_eje5_p6
    @pp7 = diagnostico.puntaje_eje5_p7
    @p_maxptos = (($participacion_p1.to_f + $participacion_p2.to_f + $participacion_p3.to_f + $participacion_p4.to_f + $participacion_p5.to_f + $participacion_p6.to_f + $participacion_p7.to_f)*100).round(3)
    @p_totalptos = (@pp1.to_f + @pp2.to_f + @pp3.to_f + @pp4.to_f + @pp5.to_f + @pp6.to_f + @pp7.to_f).round(3)
    @p_porcentaje = @p_totalptos.to_f > 0 ? ((@p_totalptos.to_f * 100) / @p_maxptos.to_f).round(3) : 0

    # -- Totales --
    @max_ptos = (@c_maxptos + @e_maxptos + @h_maxptos + @co_maxptos + @p_maxptos).to_f.round(3)
    @total_ptos = (@c_totalptos + @e_totalptos + @h_totalptos + @co_totalptos + @p_totalptos).to_f.round(3)
    @porcentaje = ((@total_ptos.to_f * 100) / @max_ptos.to_f).round(3)

#    if current_user.roles.any? { |b| b[:name] == 'escuela' }
#      render :partial => 'resumen', :layout => 'reporte'
#    else
      render :partial => 'completo', :layout => 'reporte'
#    end
  end

  def eje1_to_pdf
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @diagnostico ||= Diagnostico.new
    @competencia = @diagnostico.competencia || Competencia.new

    @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
    @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
    render :partial => "competencias", :layout => "reporte_diagnostico"
  end
  
  def eje2_to_pdf
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @diagnostico ||= Diagnostico.new
    @entorno = @diagnostico.entorno || Entorno.new
    @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
    @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
    @escuela = Escuela.find_by_clave(current_user.login)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
    end

    render :partial => "entornos", :layout => "reporte_diagnostico"
  end

  def eje3_to_pdf
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @diagnostico ||= Diagnostico.new
    @huella = @diagnostico.huella || Huella.new
    @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @s_servicio_aguas = multiple_selected_id(@huella.servicio_aguas) if @huella.servicio_aguas
    @s_elimina_residuos = multiple_selected_id(@huella.elimina_residuos) if @huella.elimina_residuos
    @focos = 0..499

    render :partial => "huellas", :layout => "reporte_diagnostico"
  end

  def eje4_to_pdf
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @diagnostico ||= Diagnostico.new
    @consumo = (@diagnostico.consumo)? @diagnostico.consumo : Consumo.new

    @escuela = Escuela.find_by_clave(current_user.login.upcase)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
    else
      @establecimientos = Establecimiento.find(:all)
    end

    @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
    @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
    @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
    @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
    @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
    @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
    @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
    @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
    @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
    @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica

    render :partial => "consumos", :layout => "reporte_diagnostico"
  end
  
  def eje5_to_pdf
    @diagnostico = Diagnostico.find(Base64.decode64(params[:id])) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
    @s_dcapacitadoras = multiple_selected_dcapacitadora(@participacion.capacitacion_padres) if  @participacion.capacitacion_padres
    cargar_proyectos_actuales

    render :partial => "participacions", :layout => "reporte_diagnostico"
  end

  private

  def set_layout
    (action_name == 'reporte_completo' || action_name == 'reporte_resumen' || action_name == 'reporte')? 'reporte' : 'diagnostico'
  end

  def no_disponible
    if current_user.has_role?("escuela")
      flash[:error] = "El proceso de diagnostico aún no está abierto"
      redirect_to :controller => "home"
    end
  end
  
  def cargar_proyectos_actuales
    @s_proyectos_ma =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'MEDIOAMBIENTE'])
    @proyectos_seleccionados_ambiente = ( @s_proyectos_ma.empty?)? 0: @s_proyectos_ma.size
    @s_proyectos_salud =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'SALUD'])
    @proyectos_seleccionados_salud = ( @s_proyectos_salud.empty?)? 0: @s_proyectos_salud.size
    @s_proyectos_dependencias =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'DEPENDENCIAS'])
    @proyectos_seleccionados_dependencias = ( @s_proyectos_dependencias.empty?)? 0: @s_proyectos_dependencias.size
  end


end