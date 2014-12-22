class DiagnosticosController < ApplicationController
  layout :set_layout
  #before_filter :login_required, :except => [:reporte_completo, :set_layout]
  before_filter :no_disponible
  
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
#    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    # -- Diagnostico ---
    @competencia = @diagnostico.competencia if @diagnostico.competencia
      # -- Operaciones --
      @cp1 = @competencia.docentes_capacitados_sma.to_i > 0 ? (((@competencia.docentes_capacitados_sma.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p1.to_f).round(3) : 0
      @cp2 = @competencia.docentes_aplican_conocimientos.to_i > 0 ? (((@competencia.docentes_aplican_conocimientos.to_f / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p2.to_f).round(3) : 0
      @cp3 = @competencia.docentes_involucran_actividades.to_i > 0 ? (((@competencia.docentes_involucran_actividades.to_f / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p3.to_f).round(3) : 0
      @cp4 = @competencia.alumnos_capacitados_docentes.to_i > 0 ? ((((@competencia.alumnos_capacitados_docentes.to_f / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p4.to_f).round(3)) : 0
      @cp5 = @competencia.alumnos_capacitados_instituciones.to_i > 0 ? (((@competencia.alumnos_capacitados_instituciones.to_f / (@escuela.alu_hom + @escuela.alu_muj)) * 100) * $competencia_p5.to_f).round(3) : 0

      @c_maxptos = (($competencia_p1.to_f + $competencia_p2.to_f + $competencia_p3.to_f + $competencia_p5.to_f + $competencia_p5.to_f)*100).round(3)
      @c_totalptos = (@cp1.to_f + @cp2.to_f + @cp3.to_f + @cp4.to_f + @cp5.to_f).round(3)
      @c_porcentaje = @c_totalptos.to_f > 0 ? ((@c_totalptos.to_f * 100) / @c_maxptos.to_f).round(3) : 0

    # -- Entorno ---
    @entorno = @diagnostico.entorno if @diagnostico.entorno
      # -- Operaciones --
      if @entorno.superficie_terreno_escuela_av.to_f > 0  and @entorno.superficie_terreno_escuela.to_f > 0
        ((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round > 25 ? @ep2 = ptos_superficie(25) : @ep2 = ptos_superficie(((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round)
      else
        @ep2 = 0
      end
      
      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      @accione_s = multiple_selected(@entorno.acciones) if @entorno.acciones
      unless @accione_s.include?("NING")
        if @diagnostico.escuela.nivel_descripcion == "BACHILLERATO"
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
          @ep6 = (((@accione_s.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
        else
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
          @ep6 = (((@accione_s.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
        end
      else
        @acciones = Accione.find(:all)
        @ep6 = 0.0
      end
      
      @e_maxptos = (($entorno_p2.to_f + $entorno_p6.to_f)*100).round(3)
      @e_totalptos = (@ep2.to_f + @ep6.to_f).round(3)
      @e_porcentaje = @e_totalptos.to_f > 0 ? ((@e_totalptos.to_f * 100) / @e_maxptos.to_f).round(3) : 0

    # -- Huella ---
    @huella = @diagnostico.huella if @diagnostico.huella
      # -- Operaciones --
      @hp1 = @huella.capacitacion_ahorro_energia.to_f > 0 ? (((@huella.capacitacion_ahorro_energia.to_f / 2 ) * 100) * $huella_p1.to_f).round(3) : 0

      if @huella.consumo_anterior.to_f > 0 and @huella.consumo_actual.to_f > 0
        @huella.consumo_anterior.to_f > @huella.consumo_actual.to_f ? @hp2 = $huella_p2 * 100 : @hp2 = 0 if @huella.consumo_anterior or @huella.consumo_actual
      else
        @hp2 = 0
      end
        
      @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
      @hp3 = @huella.focos_ahorradores.to_f > 0 ? (((@huella.focos_ahorradores.to_f / @huella.total_focos.to_f ) * 100) * $huella_p3.to_f).round(3) : 0

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
      @h_porcentaje = @h_totalptos.to_f > 0 ? ((@h_totalptos.to_f * 100) / @h_maxptos.to_f).round(3) : 0

    # -- Consumos --
    @consumo = @diagnostico.consumo if @diagnostico.consumo
      # -- Operaciones --
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
      else
        @establecimientos = Establecimiento.find(:all)
      end
      @s_establecimientos = multiple_selected(@consumo.establecimientos) if @consumo.establecimientos
      
      @consumo.conocen_lineamientos_grales == "SI" ? @cop2 = $consumo_p2 * 100 : @cop2 = 0
      
      @consumo.capacitacion_alim_bebidas == "SI" ? @cop3 = $consumo_p3 * 100 : @cop3 = 0

      @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
      @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
      @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
      @t_preparacions = Preparacion.all
      @t_utensilios = Utensilio.all
      @t_higiene = Higiene.all

      @preparacions = @s_preparacions.size > 0 ? (((@s_preparacions.size.to_f / @t_preparacions.size.to_f) * 100) * $consumo_p4) : 0
      @utensilios = @s_utensilios.size > 0 ? (((@s_utensilios.size.to_f / @t_utensilios.size.to_f) * 100) * $consumo_p4) : 0
      @higienes = @s_higienes.size > 0 ? (((@s_higienes.size.to_f / @t_higiene.size.to_f) * 100) * $consumo_p4) : 0

      @cop4 = (@s_preparacions.size + @s_utensilios.size + @s_higienes.size).to_f > 0 ? (@preparacions + @utensilios + @higienes).round(3) : 0

      @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
      @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
      @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
      @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias

      @b_saludables = Bebida.find_all_by_tipo("SALUDABLE")
      @select_bebidas = 0
      @s_bebidas.each do |bebida|
        @select_bebidas+=1 if @b_saludables.any? { |b| b[:clave] == bebida }
      end
      @bebidas = @select_bebidas.to_f > 0 ? (((@select_bebidas.to_f / @s_bebidas.size.to_f)* 100)* $consumo_p5).round(3) : 0

      @a_saludables = Alimento.find_all_by_tipo("SALUDABLE")
      @select_alimentos = 0
      @s_alimentos.each do |alimento|
        @select_alimentos+=1 if @a_saludables.any? { |b| b[:clave] == alimento }
      end
      @alimentos = @select_alimentos.to_f > 0 ? (((@select_alimentos.to_f / @s_alimentos.size.to_f)* 100)* $consumo_p5).round(3) : 0

      @bo_saludables = Botana.find_all_by_tipo("SALUDABLE")
      @select_botanas = 0
      @s_botanas.each do |botana|
        @select_botanas+=1 if @bo_saludables.any? { |b| b[:clave] == botana }
      end
      @botanas = @select_botanas.to_f > 0 ? (((@select_botanas.to_f / @s_botanas.size.to_f)* 100)* $consumo_p5).round(3) : 0

      @r_saludables = Reposteria.find_all_by_tipo("SALUDABLE")
      @select_reposterias = 0
      @s_reposterias.each do |reposteria|
        @select_reposterias+=1 if @r_saludables.any? { |b| b[:clave] == reposteria }
      end
      @reposterias =  @select_reposterias.to_f > 0 ? (((@select_reposterias.to_f / @s_reposterias.size.to_f)* 100)* $consumo_p5).round(3) : 0

      @cop5 = (@bebidas + @alimentos + @botanas + @reposterias).to_f > 0 ?  (@bebidas + @alimentos + @botanas + @reposterias) : 0

      @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
      @m_recomendables = Material.find_all_by_tipo("RECOMENDABLES")
      @select_materials = 0
      @s_materials.each do |material|
        @select_materials+=1 if @m_recomendables.any? { |b| b[:clave] == material }
      end
      @cop6 = (((@select_materials.to_f / @s_materials.size.to_f)* 100)* $consumo_p6).round(3)

      @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
      @cop7 = ptos_afisica(@s_afisicas)

      minutos_activacion_fisica = (@consumo.minutos_activacion_fisica) ? @consumo.minutos_activacion_fisica : 0
      @cop8 = ptos_minutos(minutos_activacion_fisica > 30 ? 30 : @consumo.minutos_activacion_fisica)

      @co_maxptos = (($consumo_p2.to_f + $consumo_p3.to_f + ($consumo_p4.to_f * 3) + ($consumo_p5.to_f * 4) + $consumo_p6.to_f + $consumo_p7.to_f + $consumo_p8.to_f)*100 ).round(3)
      @co_totalptos = (@cop2.to_f + @cop3.to_f + @cop4.to_f + @cop5.to_f + @cop6.to_f + @cop7.to_f + @cop8.to_f).round(3)
      @co_porcentaje = @co_totalptos.to_f > 0 ? ((@co_totalptos.to_f * 100) / @co_maxptos.to_f).round(3) : 0

      # -- Participación --
      @participacion = @diagnostico.participacion if @diagnostico.participacion
      # -- Operaciones --
      @pp2 = @participacion.num_padres_familia.to_i > 0 ? (((@participacion.capacitacion_salud_ma.to_f / @participacion.num_padres_familia.to_f ) * 100) * $participacion_p2.to_f).round(3) : 0
      @pp3 = @participacion.proy_escolares_ma.to_i > 0 ? ptos_participacion(@participacion.proy_escolares_ma) : 0
      @pp4 = @participacion.proy_escolares_salud.to_i > 0 ? ptos_participacion(@participacion.proy_escolares_salud) : 0
      @pp5 = @participacion.act_salud_ma.to_i > 0 ? ptos_participacion(@participacion.act_salud_ma) : 0

      @p_maxptos = (($participacion_p2.to_f + $participacion_p3.to_f + $participacion_p4.to_f + $participacion_p5.to_f)*100).round(3)
      @p_totalptos = (@pp2.to_f + @pp3.to_f + @pp4.to_f + @pp5.to_f).round(3)
      @p_porcentaje = @p_totalptos.to_f > 0 ? ((@p_totalptos.to_f * 100) / @p_maxptos.to_f).round(3) : 0

    # -- Totales --
      @max_ptos = (@c_maxptos + @e_maxptos + @h_maxptos + @co_maxptos + @p_maxptos).to_f.round(3)
      @total_ptos = (@c_totalptos + @e_totalptos + @h_totalptos + @co_totalptos + @p_totalptos).to_f.round(3)
      @porcentaje = ((@total_ptos.to_f * 100) / @max_ptos.to_f).round(3)

    if current_user.roles.any? { |b| b[:name] == 'escuela' }
      render :partial => 'resumen', :layout => 'reporte'
    else
      render :partial => 'completo', :layout => 'reporte'
    end
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

end