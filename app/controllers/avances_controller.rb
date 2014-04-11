require 'base64'
class AvancesController < ApplicationController
  layout 'era2014'
#  @@eje = ""
#  @@proyectos = ""

  def index
    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @diagnostico_concluido = (@diagnostico.oficializado) ? @diagnostico.oficializado : false  if @diagnostico
    if @diagnostico_concluido
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
       @finish = concluido(@ejes, @num_avance)
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
    @id, @num_avance = (Base64.decode64(params[:id])).split("-") if params[:id]
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
  end

  def save_avances
    @num_avance = params[:num_avance] if params[:num_avance]
    @avance = Avance.find(params[:id]) if params[:id]
    @avance ||= Avance.new
    @actividades = params[:actividades]
    v = valida_cuatro_evidencias_avance(params[:eje].to_i, params[:num_avance].to_i, params[:proyecto])
    if v.empty?
      @actividades.each do | a |
        @actividad_eje = Actividad.find(:first, :conditions => ["eje_id = ? AND clave = ?", params[:eje], a[0]])
        if act = Avance.find(:first, :conditions => ["actividad_id = ?", @actividad_eje.id])
            act.update_attributes!(:descripcion => a[1])
        else
           Avance.create(:numero => params[:num_avance], :descripcion => a[1], :actividad_id => @actividad_eje.id)
           eje = Eje.find(params[:eje].to_i)
            eje.update_attributes!(:avance1 => true) if @num_avance == '1'
        end
      end
      redirect_to :action => "index", :num_avance => Base64.encode64(@num_avance)
    else
      flash[:evidencias] = "Cargue archivos para la(s) evidencia(s) #{v.join(',')}"
      redirect_to :action => "add_avances", :id => Base64.encode64( params[:eje] + "-" + @num_avance )
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
    @proyecto = Proyecto.find(params[:id])
    @proyecto.avance = params[:avance].to_i
    @escuela = Escuela.find(@proyecto.diagnostico.escuela_id)
    @escuela.update_bitacora!("avance1", current_user)
    if @proyecto.save
      flash[:notice] = "El avance núm. #{params[:avance]} del proyecto fue finalizado correctamente"
    else
      flash[:notice] = "El avance del proyecto no pudo finalizarse, vuelva a intentarlo"
    end
    redirect_to :controller => "proyectos"
  end

  def concluido(ejes, avance)
    @fin = true
    ejes.each do |e|
      case avance.to_i
      when 1
        if e.avance1 == false
          @fin = false 
          break;
        end
      when 2
        if e.avance2 == false
          @fin = false
          break;
        end
      when 3
        if e.avance3 == false
          @fin = false
          break;
        end
      end
    end
    return @fin
  end


end
