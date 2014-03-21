class AvancesController < ApplicationController
  layout 'era2014'
#  @@eje = ""
#  @@proyectos = ""

  def index
    @num_avance = params[:num_avance] if params[:num_avance]
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
         @act["actividad#{n}"] = @avance[n-1][:descripcion] if @avance && @avance[n-1]
     end
    end
    a=0
  end

  def save_avances
    @num_avance = params[:num_avance] if params[:num_avance]
    @avance = Avance.find(params[:id]) if params[:id]
    @avance ||= Avance.new
    @actividades = params[:actividades]

    @actividades.each do | a |
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

    
    redirect_to :action => "index", :num_avance => @num_avance
  end

end
