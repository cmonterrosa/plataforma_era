require 'base64'
class AvancesController < ApplicationController
  layout :set_layout


  def list
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico) if @diagnostico
    @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
    
    unless @proyecto && @proyecto.oficializado
      flash[:notice] = "Para ingresar a la sección de avances es necesario concluir la etapa del proyecto"
      redirect_to :controller => "proyectos"
    end
  end

  def index
    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
    if @num_avance.to_i > 0
      @escuela = Escuela.find_by_clave(current_user.login.upcase) if current_user
      @escuela_id = @escuela.id if @escuela
      @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
      @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico) if @diagnostico

      @diagnostico_concluido = (@diagnostico.oficializado) ? @diagnostico.oficializado : false  if @diagnostico
      if @diagnostico_concluido
        @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
        @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
        @finish = concluido(@proyecto.id, @ejes, @num_avance)
#       @@eje = @ejes
#       @@proyectos = @proyecto
          
      else
        flash[:notice] = "Para iniciar la captura del proyecto, es necesario concluir la etapa de diagnóstico"
        redirect_to :action => "index", :controller => "diagnosticos"
      end
    else
      flash[:error] = "Número de avance incorrecto"
      redirect_to :action => "list"
    end
  end

  def add_avances
    @evidencia = true
    @id, @num_avance = (Base64.decode64(params[:id])).split("-") if params[:id]
    @eje = Eje.find(@id.to_i) if @id
    @catalogo_ejes = CatalogoEje.find(@eje.catalogo_eje) if @eje
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

    if @eje.catalogo_eje.clave == "EJE1"
      @competencia = Competencia.find_by_proyecto_id(@proyecto.id)
      @competencia_diagnostico = Competencia.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
      @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados

      @evidencia_diagnostico_p1 = evidencia_valida?(@eje.catalogo_eje.id, 1, @diagnostico)
      @evidencia_diagnostico_p2 = evidencia_valida?(@eje.catalogo_eje.id, 2, @diagnostico)
      @evidencia_diagnostico_p3 = evidencia_valida?(@eje.catalogo_eje.id, 3, @diagnostico)
      @evidencia_diagnostico_p4 = evidencia_valida?(@eje.catalogo_eje.id, 4, @diagnostico)
      @evidencia_diagnostico_p5 = evidencia_valida?(@eje.catalogo_eje.id, 5, @diagnostico)
    end

    if @eje.catalogo_eje.clave == "EJE2"
      @entorno = @proyecto.entorno
      @entorno_diagnostico = Entorno.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
      @escuela = Escuela.find_by_clave(current_user.login)
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
      else
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
      end
    end

    if @eje.catalogo_eje.clave == "EJE3"
      @huella = @proyecto.huella
      @huella_diagnostico = Huella.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      @focos = 0..@huella_diagnostico.total_focos.to_i
    end

    if @eje.catalogo_eje.clave == "EJE4"
      @consumo = @proyecto.consumo
      @consumo_diagnostico = Consumo.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @escuela = Escuela.find_by_clave(current_user.login.upcase)
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
      else
        @establecimientos = Establecimiento.find(:all)
      end

      @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
      @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
      @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
      @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
      @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
      @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
      @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
      @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
      @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
    end

    if @eje.catalogo_eje.clave == "EJE5"
      @participacion = @proyecto.participacion
      @participacion_diagnostico = Participacion.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_dcapacitadoras = multiple_selected_dcapacitadora(@participacion.capacitacion_padres) if  @participacion.capacitacion_padres
      cargar_proyectos_actuales
      @evidencia_diagnostico_p2 = evidencia_valida?(@eje.catalogo_eje.id, 2, @diagnostico)
      @evidencia_diagnostico_p3 = evidencia_valida?(@eje.catalogo_eje.id, 3, @diagnostico)
    end

  end

  def save_avances
    @num_avance = params[:num_avance] if params[:num_avance]
    @avance = Avance.find(params[:id]) if params[:id]
    @avance ||= Avance.new
    @actividades = params[:actividades]
    @proyecto = Proyecto.find(params[:proyecto])
    v = valida_cuatro_evidencias_avance(params[:eje].to_i, params[:num_avance].to_i, params[:proyecto].to_i)
    if v.empty?
      @actividades.each do | a |
        @actividad_eje = Actividad.find(:first, :conditions => ["eje_id = ? AND clave = ?", params[:eje], a[0]])
        eje = Eje.find(params[:eje].to_i)
        if act = Avance.find(:first, :conditions => ["actividad_id = ? and numero = ?", @actividad_eje.id, @num_avance.to_i])
            act.update_attributes!(:descripcion => a[1])
            eje.update_attributes!(:avance1 => true, :meta_lograda1 => params[:ejes][:meta_lograda1]) if @num_avance == '1'
            eje.update_attributes!(:avance2 => true, :meta_lograda2 => params[:ejes][:meta_lograda2]) if @num_avance == '2'
        else
           Avance.create(:numero => params[:num_avance], :descripcion => a[1], :actividad_id => @actividad_eje.id)
           eje.update_attributes!(:avance1 => true, :meta_lograda1 => params[:ejes][:meta_lograda1]) if @num_avance == '1'
           eje.update_attributes!(:avance2 => true, :meta_lograda2 => params[:ejes][:meta_lograda2]) if @num_avance == '2'
        end
      end
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
      @ejes = Eje.find(params[:eje]) if params[:eje]
      @act = Hash.new
      @actividades = params[:actividades] if params[:actividades]
      (1..@ejes.actividads.size).each do |n|
         @act["actividad#{n}"] = @actividades["actividad#{n}"] if  @actividades["actividad#{n}"]
      end
      @meta_lograda = params[:ejes][:meta_lograda1] if params[:ejes][:meta_lograda1]
      flash[:evidencias] = "Cargue archivos para la(s) evidencia(s) #{v.join(',')}"
     # render :action => "add_avances", :id => Base64.encode64( params[:eje] + "-" + @num_avance )
      render :action => "add_avances", :id => Base64.encode64( params[:eje] + "-")
    end




#    if evidencia_preguntas(params[:eje].to_i, params[:num_avance].to_i, params[:proyecto]) > 0
#      @actividades.each do | a |
#        @actividad_eje = Actividad.find(:first, :conditions => ["eje_id = ? AND clave = ?", params[:eje], a[0]])
#        if act = Avance.find(:first, :conditions => ["actividad_id = ?", @actividad_eje.id])
#            act.update_attributes!(:descripcion => a[1])
#        else
#           Avance.create(:numero => params[:num_avance], :descripcion => a[1], :actividad_id => @actividad_eje.id)
#           eje = Eje.find(params[:eje].to_i)
#            eje.update_attributes!(:avance1 => true) if @num_avance == '1'
#        end
#      end
#      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
#    else
#      flash[:evidencias] = "Cargue archivos para la(s) evidencia(s)"
#      redirect_to :action => "add_avances", :id => Base64.encode64( params[:eje] + "-" + @num_avance )
#    end
  end

  def concluir
    @proyecto = Proyecto.find(params[:id]) if params[:id]
    @proyecto.avance = (params[:avance].to_i + 1) if params[:avance]
#    @proyecto.avance = params[:avance].to_i if params[:avance]
    @escuela = Escuela.find(@proyecto.diagnostico.escuela_id)
    avance = (params[:avance].to_i == 1)? "avance1" : nil
    avance ||= (params[:avance].to_i == 2)? "avance2" : nil
    unless @escuela.estatu == Estatu.find_by_clave(avance) && @escuela.bitacoras.include?(Estatu.find_by_clave(avance))
      @escuela.update_bitacora!(avance, current_user)
    end
    if @proyecto.save
      flash[:notice] = "El avance núm. #{params[:avance]} del proyecto fue finalizado correctamente"
    else
      flash[:notice] = "El avance del proyecto no pudo finalizarse, vuelva a intentarlo"
    end
    redirect_to :controller => "avances", :action => "list"
  end

  def concluido(proyecto, ejes, avance)
    @fin = false
    ejes.each do |e|
      @adjuntos = Adjunto.find(:all, :conditions => ["proyecto_id = ? AND avance = ?", proyecto, avance])
      if @adjuntos.size.to_i > 0
        @fin = true
      end if @adjuntos
    end
    return @fin
  end

  def ver_avance
    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
#    @escuela_id = params[:escuela]).id if params[:escuela]
    @diagnostico = Diagnostico.find_by_escuela_id(params[:escuela]) if params[:escuela]
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)

    if @proyecto.oficializado
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
    else
      flash[:notice] = "Es necesario concluir la etapa de Proyecto"
      redirect_to :action => "index", :controller => "Proyecto"
    end
  end

  def avance_to_pdf
#    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
    @evidencia = params[:evidencia] if params[:evidencia]
    if current_user.has_role?(:adminplat) || current_user.has_role?(:enlaceevaluador)
      @escuela_id = Escuela.find(params[:escuela]).id if params[:escuela]
    else
      @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    end
    @escuela = Escuela.find(@escuela_id) if @escuela_id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)

    if @proyecto.oficializado
      @catalogo_ejes = CatalogoEje.find_by_clave(params[:eje])
      @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)
      @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
      @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )
        if params[:eje] == "EJE1"
          @competencia = Competencia.find_by_proyecto_id(@proyecto.id)
          @competencia_diagnostico = Competencia.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
          @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
          @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
          
          @evidencia_diagnostico_p1 = evidencia_valida?(1, 1, @diagnostico)
          @evidencia_diagnostico_p2 = evidencia_valida?(1, 2, @diagnostico)
          @evidencia_diagnostico_p3 = evidencia_valida?(1, 3, @diagnostico)
          @evidencia_diagnostico_p4 = evidencia_valida?(1, 4, @diagnostico)
          @evidencia_diagnostico_p5 = evidencia_valida?(1, 5, @diagnostico)
        end

        if params[:eje] == "EJE2"
          @entorno = Entorno.find_by_proyecto_id(@proyecto.id)
          @entorno_diagnostico = Entorno.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
          @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
          @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
#          @escuela = Escuela.find_by_clave(current_user.login)
          @escuela = Escuela.find(@escuela_id)
          if @escuela.nivel_descripcion == "BACHILLERATO"
            @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
          else
            @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
          end
        end

        if params[:eje] == "EJE3"
          @huella = Huella.find_by_proyecto_id(@proyecto.id)
          @huella_diagnostico = Huella.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
          @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
          @focos = 0..@huella_diagnostico.total_focos.to_i
        end

        if params[:eje] == "EJE4"
          @consumo = Consumo.find_by_proyecto_id(@proyecto.id)
          @consumo_diagnostico = Consumo.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
#          @escuela = Escuela.find_by_clave(current_user.login.upcase)
          @escuela = Escuela.find(@escuela_id)
          if @escuela.nivel_descripcion == "BACHILLERATO"
            @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
          else
            @establecimientos = Establecimiento.find(:all)
          end

          @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
          @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
          @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
          @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
          @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
          @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
          @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
          @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
          @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
        end

        if params[:eje] == "EJE5"
          @participacion = Participacion.find_by_proyecto_id(@proyecto.id)
          @participacion_diagnostico = Participacion.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
          @s_dcapacitadoras = multiple_selected_dcapacitadora(@participacion.capacitacion_padres) if  @participacion.capacitacion_padres
          cargar_proyectos_actuales
          @evidencia_diagnostico_p2 = evidencia_valida?(5, 2, @diagnostico)
          @evidencia_diagnostico_p3 = evidencia_valida?(5, 3, @diagnostico)
        end
    else
      flash[:notice] = "Es necesario concluir la etapa de Proyecto"
      redirect_to :action => "index", :controller => "Proyecto"
    end
  end

  def check_competencia
    @competencia = Competencia.find(params[:id])
    @proyecto = @competencia.proyecto
    @diagnostico = @proyecto.diagnostico
    @evidencia = true
    @catalogo_ejes = CatalogoEje.find_by_clave("EJE1")
    @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)

    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

    @competencia_diagnostico = Competencia.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)

    @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
    @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados

    @id, @num_avance = (Base64.decode64(params[:eje_avance])).split("-")
    @competencia.num_avance_attribute(@num_avance)
    if @competencia.valid?
      flash[:notice] = "Avance de Eje 1 se realizó correctamente"
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
      flash[:evidencias] = @competencia.errors.full_messages.join(", ")
      render :action => "add_avances", :id => params[:eje_avance]
    end

  end

  def check_entorno
    @entorno = Entorno.find(params[:id])
    @proyecto = @entorno.proyecto
    @diagnostico = @proyecto.diagnostico
    @evidencia = true
    @catalogo_ejes = CatalogoEje.find_by_clave("EJE2")
    @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)

    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

    @entorno_diagnostico = Entorno.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)

    @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
    @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
    @escuela = Escuela.find_by_clave(current_user.login)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
    end

    @id, @num_avance = (Base64.decode64(params[:eje_avance])).split("-")
    @entorno.num_avance_attribute(@num_avance)
    if @entorno.valid?
      flash[:notice] = "Avance de Eje 2 se realizó correctamente"
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
       flash[:evidencias] = @entorno.errors.full_messages.join(", ")
       render :action => "add_avances", :id => params[:eje_avance]
    end

  end

  def check_huella
    @huella = Huella.find(params[:id])
    @proyecto = @huella.proyecto
    @diagnostico = @proyecto.diagnostico
    @evidencia = true
    @catalogo_ejes = CatalogoEje.find_by_clave("EJE3")
    @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)

    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

    @huella_diagnostico = Huella.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)

    @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
    @focos = 0..@huella_diagnostico.total_focos.to_i

    @id, @num_avance = (Base64.decode64(params[:eje_avance])).split("-")
    @huella.num_avance_attribute(@num_avance)
    
    if @huella.valid?
      flash[:notice] = "Avance de Eje 3 se realizó correctamente"
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
      flash[:evidencias] = @huella.errors.full_messages.join(", ")
      render :action => "add_avances", :id => params[:eje_avance]
    end

  end

  def check_consumo
      @consumo = Consumo.find(params[:id])
      @proyecto = @consumo.proyecto
      @evidencia = true
      @diagnostico = @proyecto.diagnostico
      @catalogo_ejes = CatalogoEje.find_by_clave("EJE4")
      @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)
      @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
      @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )
      @consumo_diagnostico = Consumo.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)
      @escuela = Escuela.find_by_clave(current_user.login.upcase)
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @establecimientos = Establecimiento.find(:all, :conditions => ["nivel not in ('BASICA')"])
      else
        @establecimientos = Establecimiento.find(:all)
      end

      @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
      @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
      @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
      @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
      @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
      @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
      @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias
      @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
      @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
      @id, @num_avance = (Base64.decode64(params[:eje_avance])).split("-")
      @consumo.num_avance_attribute(@num_avance)
      if @consumo.valid?
        flash[:notice] = "Avance de Eje 4 se realizó correctamente"
        redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
      else
        flash[:evidencias] = @consumo.errors.full_messages.join(", ")
        render :action => "add_avances", :id => params[:eje_avance]
      end
  end

  def check_participacion
    @participacion = Participacion.find(params[:id])
    @proyecto = @participacion.proyecto
    @diagnostico = @proyecto.diagnostico
    @evidencia = true
    @catalogo_ejes = CatalogoEje.find_by_clave("EJE5")
    @eje = Eje.find_by_catalogo_eje_id_and_proyecto_id(@catalogo_ejes.id, @proyecto.id)

    @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
    @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

    @participacion_diagnostico = Participacion.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)

    @s_dcapacitadoras = multiple_selected_dcapacitadora(@participacion.capacitacion_padres) if  @participacion.capacitacion_padres
    cargar_proyectos_actuales

    @id, @num_avance = (Base64.decode64(params[:eje_avance])).split("-")
    @participacion.num_avance_attribute(@num_avance)
    if @participacion.valid?
      flash[:notice] = "Avance de Eje 5 se realizó correctamente"
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
      flash[:evidencias] = @participacion.errors.full_messages.join(", ")
      render :action => "add_avances", :id => params[:eje_avance]
    end

  end



  private

  def set_layout
    (action_name == 'avance_to_pdf' or action_name == 'ver_avance')? 'reporte_avance' : 'era2016'
  end

  #### Funcion que guarda los proyectos escolares por tipo #####
  def guardar_proyectos(parametros, tipo, participacion)
      ids_olds =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, tipo]).map{|i|i.id} if @participacion
      Pescolar.find(ids_olds).each do |p| p.destroy end unless ids_olds.empty?
      if @projects = parametros
          ids_olds =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, tipo]).map{|i|i.id}
            (1..12).each do |numero|
              @participacion.pescolars << Pescolar.new(:participacion_id => participacion.id, :materia => tipo, :descripcion => @projects["descripcion_#{numero}"], :nombre => @projects["nombre_#{numero}"], :dependencia_secretaria_apoya => @projects["dependencia_secretaria_apoya_#{numero}"]  ) if @projects.has_key?("nombre_#{numero}")
           end
      end
  end

  ### Funcion que recupera los datos de los proyectos actuales #####
  def cargar_proyectos_actuales
#       @s_dcapacitadoras = multiple_selected(@participacion.dcapacitadoras)
      ### Proyectos medio ambiente ###
        @s_proyectos_ma =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'MEDIOAMBIENTE'])
        @proyectos_seleccionados_ambiente = ( @s_proyectos_ma.empty?)? 0: @s_proyectos_ma.size
      ### Proyectos salud ###
        @s_proyectos_salud =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'SALUD'])
        @proyectos_seleccionados_salud = ( @s_proyectos_salud.empty?)? 0: @s_proyectos_salud.size
      ### Proyectos dependencias ###
        @s_proyectos_dependencias =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'DEPENDENCIAS'])
        @proyectos_seleccionados_dependencias = ( @s_proyectos_dependencias.empty?)? 0: @s_proyectos_dependencias.size
  end
  
end
