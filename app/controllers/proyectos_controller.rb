require 'base64'
class ProyectosController < ApplicationController
  layout :set_layout

  before_filter :check_is_available, :except => "proyect_to_pdf"

  require_role [:escuela]
#  skip_before_filter :verify_authenticity_token, :only => [:save_first_section, :second_section_proyect]


  def check_is_available
    unless Time.now < (Time.parse FECHA_FINAL_PROYECTO)
      flash[:warning] = "La etapa del proyecto estará disponible hasta que su diagnóstico haya concluido y sea revisado"
      redirect_to :controller => "diagnosticos"
    end
  end

  def index
     flash[:warning] = "La etapa del proyecto estará disponible hasta que su diagnóstico haya concluido y sea revisado"
     redirect_to :controller => "diagnosticos"
  end

  def index_old
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @diagnostico_concluido = (@diagnostico.oficializado) ? @diagnostico.oficializado : false  if @diagnostico
    @proyecto_habilitado = true
    notice = (@proyecto_habilitado) ? "Bienvenido a la captura del proyecto" : "La fase de captura de proyecto aún no se encuentra disponible"
    if @diagnostico_concluido && @proyecto_habilitado
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
    else
      flash[:warning] = notice
      redirect_to :action => "index", :controller => "diagnosticos"
    end
  end

  def get_contenido_ejes
    unless params[:catalogo_catalogo_eje_id].empty?
      @catalogo_ejes = CatalogoEje.find_by_clave( params[:catalogo_catalogo_eje_id]) if params[:catalogo_catalogo_eje_id]
      @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
      @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
      @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)
      @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
      @lineas = LineasAccion.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ])
      @indicadores = Indicadore.find(:all, :conditions => ["catalogo_eje_id = ?", @catalogo_ejes.id ] )

      if params[:catalogo_catalogo_eje_id] == "EJE1"
        @competencia = Competencia.new
        @competencia_diagnostico = Competencia.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
        @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
        @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
      end

      if params[:catalogo_catalogo_eje_id] == "EJE2"
        @entorno = Entorno.new
        @entorno_diagnostico = Entorno.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
        @s_espacios_diagnostico = multiple_selected_espacios(@entorno_diagnostico.escuelas_espacios) if @entorno_diagnostico.escuelas_espacios
        @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
        @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
        @escuela = Escuela.find_by_clave(current_user.login)
        if @escuela.nivel_descripcion == "BACHILLERATO"
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
        else
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
        end
      end

      if params[:catalogo_catalogo_eje_id] == "EJE3"
        @huella = Huella.new
        @huella_diagnostico = Huella.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
        @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
        @focos = 0..@huella_diagnostico.total_focos.to_i
      end

      if params[:catalogo_catalogo_eje_id] == "EJE4"
        @consumo = Consumo.new
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
      
    end
    render :partial => "contenido_eje", :layout => "only_jquery"
  end

  def new_proyecto
    @proyecto = Proyecto.create(:diagnostico_id => Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
    @escuela = Escuela.find_by_clave(current_user.login.upcase)
    if @proyecto
      @escuela.update_bitacora!("proy-inic", current_user)
      redirect_to :action => "new_or_edit", :escuela_id => params[:escuela_id]
    else
      flash[:error] = "No se pudo iniciar el proyecto"
    end
  end

  def new_or_edit
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
  end

  def edit
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
  end

  def save
    @proyecto = Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto])
      flash[:notice] = "Nueva captura de eje"
      redirect_to :action => "seccion_eje"
    else
      flash[:error] = "No se pudo guardar el proyecto"
    end
  end

  def save_proyecto
    @proyecto = Proyecto.find(params[:id])
    if @proyecto.update_attributes(params[:proyecto])
      flash[:notice] = "Nueva captura de eje"
      redirect_to :action => "seccion_eje"
    else
      flash[:error] = "No se pudo crear el proyecto"
    end
  end

  def seccion_eje
#    @eje = Eje.find(params[:id]) if params[:id]
    @eje = Eje.new
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @id_usados = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id])
    unless @id_usados.empty?
      @catalogo_ejes = CatalogoEje.find(:all, :conditions => ["id not in (#{convertir_array(@id_usados,'eje').join(',')})"] )
    else
      @catalogo_ejes = CatalogoEje.find(:all)
    end
  end

  def edit_eje
    @eje = Eje.find(params[:id]) if params[:id]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @eva_diagnostico = Evaluacion.new(:diagnostico_id => @diagnostico.id.to_i)
    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
    @indicadores = @eje.catalogo_eje.indicadores
    @lineas = @eje.catalogo_eje.lineas_accions
    @lineas ||= LineasAccion.find(:all)
    @indicadores ||= Indicadore.find(:all)
    @catalogo_ejes = CatalogoEje.find(:all)

    if @proyecto.competencia and @eje.catalogo_eje.clave == "EJE1"
      @competencia = @proyecto.competencia
      @competencia_diagnostico = Competencia.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
      @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
    end

    if @eje.catalogo_eje.clave == "EJE2"
      @entorno = @proyecto.entorno
      @entorno_diagnostico = Entorno.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
      @s_espacios_diagnostico = multiple_selected_espacios(@entorno_diagnostico.escuelas_espacios) if @entorno_diagnostico.escuelas_espacios
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

  end

  def delete_eje
    @eje = Eje.find(params[:id])
    @eje_nombre = @eje.catalogo_eje.descripcion
    if @eje.catalogo_eje.clave == "EJE1"
      AlumnosCapacitado.delete_all("competencia_id = #{@eje.proyecto.competencia.id}")
      DocentesCapacitado.delete_all("competencia_id = #{@eje.proyecto.competencia.id}")
      @eje.proyecto.competencia.destroy
    end
    if @eje.catalogo_eje.clave == "EJE2"
      EscuelasEspacio.delete_all("entorno_id = #{@eje.proyecto.entorno.id}")
      @eje.proyecto.entorno.acciones.destroy
      @eje.proyecto.entorno.destroy
    end
    if @eje.destroy
      flash[:notice] = "Eje: #{@eje_nombre} has sido eliminado."
    else
      flash[:error] = "Error al eliminar el eje: #{@eje_nombre}."
    end
    redirect_to :action => "index"
  end

  def proyect_to_pdf
    @escuela_id = Escuela.find(params[:id]) if params[:id]
    @escuela_id ||= Escuela.find_by_clave(current_user.login.upcase).id
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id)
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
    unless @proyecto
      render :text => "<h1 style='color: red;' align='center'>No existe proyecto registrado</h2>"
    end
  end

 def oficializar
    @proyecto = Proyecto.find(params[:id])
    @proyecto.oficializado = true
    @proyecto.avance = params[:avance].to_i
    @proyecto.fecha_oficializado = Time.now
    @escuela = Escuela.find(@proyecto.diagnostico.escuela_id)
    @escuela.update_bitacora!("proy-fin", current_user)
    if @proyecto.save
      flash[:notice] = "El proyecto fue finalizado correctamente"
    else
      flash[:notice] = "El proyecto no pudo finalizarse, vuelva a intentarlo"
    end
    redirect_to :action => "index"
  end

 #---- competencia proyecto ----
 def save_competencia
    @competencia = Competencia.find(params[:id]) if params[:id]
    @competencia ||= Competencia.new
    @proyecto = @competencia.proyecto = Proyecto.find(params[:proyecto].to_i)
    @competencia.update_attributes(params[:competencia])

    if params[:dcapacitadoras]
      @s_docentes = []
      params[:dcapacitadoras].each_key { |id| @s_docentes << id }
      @competencia.docentes_capacitados.each { |docente| docente.delete if @s_docentes.include?("#{docente.dcapacitadora_id.to_s}") == false }
      params[:dcapacitadoras].each_key do |dcap|
        dcapacitadora = Dcapacitadora.find(dcap)
        docente_capacitado = DocentesCapacitado.find_by_dcapacitadora_id_and_competencia_id(dcapacitadora.id, @competencia.id)
        docente_capacitado ||= DocentesCapacitado.new
        docente_capacitado.competencia_id = @competencia
        docente_capacitado.dcapacitadora_id = dcapacitadora.id
        docente_capacitado.descripcion_dep = params[:dcapacitadorasOTRA] if params[:dcapacitadorasOTRA] and dcapacitadora.clave == "OTRA"
        docente_capacitado.numero = params[:dcapacitadora][:"#{dcapacitadora.clave}"].to_i
        @competencia.docentes_capacitados << docente_capacitado
      end
    else
      @competencia.docentes_capacitados.each { |i| i.delete } if @competencia.docentes_capacitados
    end

    if params[:acapacitadoras]
      @s_alumnos = []
      params[:acapacitadoras].each_key { |id| @s_alumnos << id }
      @competencia.alumnos_capacitados.each { |alumno| alumno.delete if @s_alumnos.include?("#{alumno.dcapacitadora_id.to_s}") == false }
      params[:acapacitadoras].each_key do |dcap|
        dcapacitadora = Dcapacitadora.find(dcap)
        alumno_capacitado = AlumnosCapacitado.find_by_dcapacitadora_id_and_competencia_id(dcapacitadora.id, @competencia.id)
        alumno_capacitado ||= AlumnosCapacitado.new
        alumno_capacitado.competencia_id = @competencia
        alumno_capacitado.dcapacitadora_id = dcapacitadora.id
        alumno_capacitado.descripcion_dep = params[:acapacitadorasOTRA] if params[:acapacitadorasOTRA] and dcapacitadora.clave == "OTRA"
        alumno_capacitado.numero = params[:acapacitadora][:"#{dcapacitadora.clave}"].to_i
        @competencia.alumnos_capacitados << alumno_capacitado
      end
    else
      @competencia.alumnos_capacitados.each { |i| i.delete } if @competencia.alumnos_capacitados
    end

    @eje = Eje.find(params[:eje_id]) if params[:eje_id]
    @eje ||= Eje.new

    @eje.catalogo_eje_id = CatalogoEje.find_by_clave("EJE1").id
    @eje.objetivo_especifico = params[:eje][:objetivo_especifico] if params[:eje][:objetivo_especifico]
    @eje.meta = params[:eje][:meta] if params[:eje][:meta]
    @eje.proyecto_id = @proyecto.id

    if @competencia.save and @eje.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "proyectos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      flash[:evidencias] = @competencia.errors.full_messages.join(", ")

      @s_dcapacitadoras = multiple_selected_dcapacitadora(@competencia.docentes_capacitados) if @competencia.docentes_capacitados
      @s_acapacitadoras = multiple_selected_dcapacitadora(@competencia.alumnos_capacitados) if @competencia.alumnos_capacitados
      render :action => "get_contenido_ejes", :catalogo_catalogo_eje_id => params[:catalogo][:catalogo_eje_id], :layout => "era2014"
    end
  end

 def save_entorno
    @entorno = Entorno.find(params[:id]) if params[:id]
    @entorno ||= Entorno.new
    @proyecto = @entorno.proyecto = Proyecto.find(params[:proyecto].to_i)
    @entorno.update_attributes(params[:entorno])

    if params[:acciones]
        @acciones = []
        params[:acciones].each { |op| @acciones << Accione.find_by_clave(op)  }
        @entorno.acciones = Accione.find(@acciones)
    else
        @entorno.acciones.delete_all
    end

    if params[:espacios]
      @s_espacios = []
      params[:espacios].each_key { |id| @s_espacios << id }
      @entorno.escuelas_espacios.each { |escuela_espacio| escuela_espacio.delete if @s_espacios.include?("#{escuela_espacio.espacio_id.to_s}") == false }
      params[:espacios].each_key do |esp|
        espacio = Espacio.find(esp)
        espacio_escuela = EscuelasEspacio.find_by_entorno_id_and_espacio_id(@entorno.id, espacio.id)
        espacio_escuela ||= EscuelasEspacio.new
        espacio_escuela.entorno_id = @entorno
        espacio_escuela.espacio_id = espacio.id
        espacio_escuela.numero = params[:"#{espacio.clave}"].to_f
        @entorno.escuelas_espacios << espacio_escuela
      end
    else
      @entorno.escuelas_espacios.each { |i| i.delete } if @entorno.escuelas_espacios
    end
    
    @eje = Eje.find(params[:eje_id]) if params[:eje_id]
    @eje ||= Eje.new

    @eje.catalogo_eje_id = CatalogoEje.find_by_clave("EJE2").id
    @eje.objetivo_especifico = params[:eje][:objetivo_especifico] if params[:eje][:objetivo_especifico]
    @eje.meta = params[:eje][:meta] if params[:eje][:meta]
    @eje.proyecto_id = @proyecto.id

    if @entorno.save and @eje.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "proyectos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      flash[:evidencias] = @entorno.errors.full_messages.join(", ")

      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      @escuela = Escuela.find_by_clave(current_user.login)
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
      else
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
      end
      render :action => "get_contenido_ejes", :catalogo_catalogo_eje_id => params[:catalogo][:catalogo_eje_id], :layout => "era2014"
    end
 end

 def save_huella
    @huella = Huella.find(params[:id]) if params[:id]
    @huella ||= Huella.new
    @proyecto = @huella.proyecto = Proyecto.find(params[:proyecto].to_i)
    @huella.update_attributes(params[:huella])

    if params[:inorganicos]
      @inorganicos = []
      params[:inorganicos].each { |op| @inorganicos << Inorganico.find_by_clave(op)  }
      @huella.inorganicos = Inorganico.find(@inorganicos)
    else
      @huella.inorganicos.delete_all
    end

    @eje = Eje.find(params[:eje_id]) if params[:eje_id]
    @eje ||= Eje.new

    @eje.catalogo_eje_id = CatalogoEje.find_by_clave("EJE3").id
    @eje.objetivo_especifico = params[:eje][:objetivo_especifico] if params[:eje][:objetivo_especifico]
    @eje.meta = params[:eje][:meta] if params[:eje][:meta]
    @eje.proyecto_id = @proyecto.id

    if @huella.save and @eje.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :controller => "proyectos"
    else
      flash[:error] = "No se pudo guardar, verifique los datos"
      flash[:evidencias] = @huella.errors.full_messages.join(", ")

      @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
      render :action => "get_contenido_ejes", :catalogo_catalogo_eje_id => params[:catalogo][:catalogo_eje_id], :layout => "era2014"
    end
 end

  private

  def convertir_array(array,field)
    arreglo =[]
    array.each do |a|
      arreglo << a.catalogo_eje_id if field =='eje'
      arreglo << a.lineas_accion_id if field =='linea'
      arreglo << a.indicadore_id if field =='indicador'
    end
    return arreglo
  end

  def set_layout
    (action_name == 'proyect_to_pdf')? 'reporte' : 'era2014'
  end

end
