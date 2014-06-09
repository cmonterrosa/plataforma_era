require 'base64'
class AvancesController < ApplicationController
  layout :set_layout
#  @@eje = ""
#  @@proyectos = ""

  def list
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico) if @diagnostico
    
    unless @proyecto && @proyecto.oficializado
      flash[:notice] = "Para ingresar a la sección de avances es necesario concluir la etapa del proyecto"
      redirect_to :controller => "proyectos"
    end
  end

  def index
    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
    if @num_avance.to_i > 0
      @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
      @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
      @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico) if @diagnostico

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
    else
      flash[:error] = "Número de avance incorrecto"
      redirect_to :action => "list"
    end
  end

  def add_avances
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
    @id, @num_avance = (Base64.decode64(params[:id])).split("-") if params[:id]
    @ejes = Eje.find(@id) if @id
    @avance = Array.new
    @ejes.actividads.each do | actividad |
      if @av = Avance.find(:first, :conditions => ["actividad_id = ? and numero = ?", actividad.id, @num_avance.to_i])
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
    @escuela = Escuela.find(@proyecto.diagnostico.escuela_id)
    @escuela.update_bitacora!("avance1", current_user)
    if @proyecto.save
      flash[:notice] = "El avance núm. #{params[:avance]} del proyecto fue finalizado correctamente"
    else
      flash[:notice] = "El avance del proyecto no pudo finalizarse, vuelva a intentarlo"
    end
    redirect_to :controller => "avances", :action => "list"
  end

  def concluido(ejes, avance)
    @fin = true
    ejes.each do |e|
      case avance.to_i
        when 1
          if e.avance1 == false
            @fin = false
          end
          break;
        when 2
          if e.avance2 == false
            @fin = false
          end
          break;
        when 3
          if e.avance3 == false
            @fin = false
          end
          break;
      end
    end
    return @fin
  end

  def avance_to_pdf
    @num_avance = Base64.decode64(params[:num_avance]) if params[:num_avance]
    @escuela_id = Escuela.find_by_clave(current_user.login.upcase).id if current_user
    @diagnostico = Diagnostico.find_by_escuela_id(@escuela_id) if @escuela_id
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)

    if @proyecto.oficializado
       @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico)
       @ejes = Eje.find(:all, :conditions => ["proyecto_id = ?", @proyecto.id ]) if @proyecto
    else
      flash[:notice] = "Es necesario concluir la etapa de Proyecto"
      redirect_to :action => "index", :controller => "Proyecto"
    end
  end

  private

  def set_layout
    (action_name == 'avance_to_pdf')? 'reporte_avance' : 'era2014'
  end
end
