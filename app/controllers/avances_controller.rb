class AvancesController < ApplicationController
  layout 'era2014'
#  @@eje = ""
#  @@proyectos = ""

  def index
    @num_avance = params[:avance] if params[:avance]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @diagnostico_concluido = (@diagnostico.oficializado) ? @diagnostico.oficializado : false  if @diagnostico
    if @diagnostico_concluido
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
#       @@eje = @ejes
#       @@proyectos = @proyecto
    else
      flash[:notice] = "Para iniciar la captura del proyecto, es necesario concluir la etapa de diagnóstico"
      redirect_to :action => "index", :controller => "diagnosticos"
    end
  end

  def add_avances
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
    @id, @num_avance = params[:id].split("-") if params[:id]
    @eje = Eje.find(@id) if @id
    @avance = Array.new
    @eje.actividads.each do | actividad |
      if @av = Avance.find(:first, :conditions => ["actividad_id = ?", actividad.id])
      @avance << @av
      end
    end

    @act = Hash.new
    unless @avance.empty?
    (1..@avance.size).each do |n|
         @act["avance#{n}"] = @avance[n-1][:descripcion] if @avance && @avance[n-1]
     end
    else
      (1..4).each do |n|
         @act["avance#{n}"] = ''
      end
    end
    a=0
  end

  def save_avances
    @avance = Avance.find(params[:id]) if params[:id]
    @avance ||= Avance.new
    @actividades = params[:actividades]
#    @actividad = Actividad.find(:all, :conditions => ["eje_id = ?", params[:eje]])
#    @actividad.each do | actividad |
#      actividad.avances << Avance.create(:numero => params[:num_avance], :descripcion => params[:avance][:actividad1], :actividad_id => actividad.id) if actividad.clave == "actividad1"
#      actividad.avances << Avance.create(:numero => params[:num_avance], :descripcion => params[:avance][:actividad2], :actividad_id => actividad.id) if actividad.clave == "actividad2"
#      actividad.avances << Avance.create(:numero => params[:num_avance], :descripcion => params[:avance][:actividad3], :actividad_id => actividad.id) if actividad.clave == "actividad3"
#      actividad.avances << Avance.create(:numero => params[:num_avance], :descripcion => params[:avance][:actividad3], :actividad_id => actividad.id) if actividad.clave == "actividad4"
#    end
    
    @actividades.each do |a|
        @actividad_eje = Actividad.find(:first, :conditions => ["eje_id = ? AND clave = ?", params[:eje], a[0]])
        if act = Avance.find(:first, :conditions => ["actividad_id = ?", @actividad_eje.id])
            act.update_attributes!(:descripcion => a[1])
        else
           Avance.create(:numero => params[:num_avance], :descripcion => a[1], :actividad_id => @actividad_eje.id)
        end
      end if @actividades

#    if @eje.update_attributes(params[:eje])
#       flash[:notice] = "Registro guardado correctamente"
#       redirect_to :controller => "proyectos", :action => "index"
#    else
#       flash[:error] = "No se pudo crear el eje a desarrollar"
#    end

    
    redirect_to :action => "index"
  end



#  def new_proyecto
#    @proyecto = Proyecto.create(:diagnostico_id => Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
#    @escuela = Escuela.find_by_clave(current_user.login.upcase)
#    if @proyecto
#      @escuela.update_bitacora!("proy-inic", current_user)
#      redirect_to :action => "new_or_edit", :escuela_id => params[:escuela_id]
#    else
#      flash[:error] = "No se pudo iniciar el proyecto"
#    end
#  end

#  def new_or_edit
#    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
#  end

#  def edit
#    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(params[:escuela_id]).id)
#  end

#  def save
#    @proyecto = Proyecto.find(params[:id])
#    if @proyecto.update_attributes(params[:proyecto])
#      flash[:notice] = "Nueva captura de eje"
#      redirect_to :action => "seccion_eje"
#    else
#      flash[:error] = "No se pudo guardar el proyecto"
#    end
#  end

#  def save_proyecto
#    @proyecto = Proyecto.find(params[:id])
#    if @proyecto.update_attributes(params[:proyecto])
#      flash[:notice] = "Nueva captura de eje"
#      redirect_to :action => "seccion_eje"
#    else
#      flash[:error] = "No se pudo crear el proyecto"
#    end
#  end

#  def seccion_eje
#    @eje = Eje.find(params[:id]) if params[:id]
#    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
#    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
#    @id_usados = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id])
#    unless @id_usados.empty?
#      @catalogo_ejes = CatalogoEje.find(:all, :conditions => ["id not in (#{convertir_array(@id_usados,'eje').join(',')})"] )
#    else
#      @catalogo_ejes = CatalogoEje.find(:all)
#    end
#  end

#  def edit_eje
#    @eje = Eje.find(params[:id]) if params[:id]
#    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id
#    @proyecto = Proyecto.find_by_diagnostico_id(Diagnostico.find_by_escuela_id(@escuela_id).id)
#    @indicadores = @eje.catalogo_eje.indicadores
#    @lineas = @eje.catalogo_eje.lineas_accions
#    @lineas ||= LineasAccion.find(:all)
#    @indicadores ||= Indicadore.find(:all)
#    @catalogo_ejes = CatalogoEje.find(:all)
#    @actividades = Hash.new
#    (1..@eje.actividads.size).each do |n|
#         @actividades["actividad#{n}"] = @eje.actividads[n-1].descripcion if @eje && @eje.actividads[n-1]
#     end
#   end

#  def delete_eje
#    @eje = Eje.find(params[:id])
#    @eje_nombre = @eje.catalogo_eje.descripcion
#    if @eje.destroy
#      flash[:notice] = "Eje: #{@eje_nombre} has sido eliminado."
#    else
#      flash[:error] = "Error al eliminar el eje: #{@eje_nombre}."
#    end
#    redirect_to :action => "index"
#  end

#  def oficializar
#    @proyecto = Proyecto.find(params[:id])
#    @proyecto.oficializado = true
#    @proyecto.fecha_oficializado = Time.now
#    @escuela = Escuela.find(@proyecto.diagnostico.escuela_id)
#    @escuela.update_bitacora!("proy-fin", current_user)
#    if @proyecto.save
#      flash[:notice] = "El proyecto fue finalizado correctamente"
#    else
#      flash[:notice] = "El proyecto no pudo finalizarse, vuelva a intentarlo"
#    end
#    redirect_to :action => "index"
#  end

#  private

#  def convertir_array(array,field)
#    arreglo =[]
#    array.each do |a|
#      arreglo << a.catalogo_eje_id if field =='eje'
#      arreglo << a.lineas_accion_id if field =='linea'
#      arreglo << a.indicadore_id if field =='indicador'
#    end
#    return arreglo
#  end

#  def set_layout
#    (action_name == 'proyect_to_pdf')? 'reporte' : 'era2014'
#  end

end
