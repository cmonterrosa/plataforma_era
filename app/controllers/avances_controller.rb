class AvancesController < ApplicationController
  layout 'era2014'
  @@eje = Array.new
  @@proyectos = Proyecto.new

  def index
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @diagnostico_concluido = (@diagnostico.oficializado) ? @diagnostico.oficializado : false  if @diagnostico
    if @diagnostico_concluido
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
       @@eje = @ejes
       @@proyectos = @proyecto
       a=0
    else
      flash[:notice] = "Para iniciar la captura del proyecto, es necesario concluir la etapa de diagnóstico"
      redirect_to :action => "index", :controller => "diagnosticos"
    end
  end

  def add_avances
    @proyecto = @@proyectos
    @eje = @@eje
    a=0
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
