class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
    cargar_proyectos_actuales
   end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @diagnostico = @participacion.diagnostico = Diagnostico.find(params[:diagnostico])
    guardar_proyectos(params[:pescolaresambiente], "MEDIOAMBIENTE", @participacion)
    guardar_proyectos(params[:pescolaressalud], "SALUD", @participacion)
    guardar_proyectos(params[:pescolaresdependencias], "DEPENDENCIAS", @participacion)
    validador = valida_evidencias_proyectos(@participacion)
    if validador["valido"]
        ## Dependencias Capacitadoras ##
        @capacitadoras = ( params[:capacitacion]) ?  params[:capacitacion] : Array.new
        @capacitadoras.each do |c|
           dc = Dcapacitadora.find_by_clave(c.last)
           capacitacion = CapacitacionPadre.find_by_dcapacitadora_id(dc.id) if dc
           capacitacion ||= CapacitacionPadre.new
           capacitacion.participacion_id  ||= @participacion.id if @participacion
           capacitacion.dcapacitadora_id ||= dc.id if dc
           capacitacion.numero_capacitaciones =(params[:capacitadora]["#{dc.clave}"]) ?  params[:capacitadora]["#{dc.clave}"] : nil
           (capacitacion.numero_capacitaciones) ? capacitacion.save : nil
        end
        (@capacitadoras.empty?)? (@participacion.capacitacion_padres.each{|x|x.destroy}) : true

        #### Si apenas se va a crear el registro, validamos si lleva proyectos y si tiene evidencias
        if @participacion.save
          flash[:notice] = "Registro guardado correctamente"
          redirect_to :controller => "diagnosticos"
        else
          flash[:evidencias] = @participacion.errors.full_messages.join(", ")
          cargar_proyectos_actuales
          render :action => "new_or_edit"
        end

    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue evidencias para la(s) pregunta(s): #{errores}"
      cargar_proyectos_actuales
      render :action => "new_or_edit"
    end
  end

  ### Funciones AJAX de recuperacion de datos de proyectos de escuelas ###

  def formularios_proyectos_ambientes
    @proyectos_seleccionados_ambiente = (params[:proyectos][:ambiente])? params[:proyectos][:ambiente].to_i : Array.new
    @participacion = Participacion.find(params[:informacion][:participacion]) if params[:informacion][:participacion].size > 0
    render :partial => "formularios_proyectos_ambientes", :layout => "only_jquery"
  end

  def formularios_proyectos_salud
    @proyectos_seleccionados_salud = (params[:proyectos][:salud])? params[:proyectos][:salud].to_i : Array.new
    @participacion = Participacion.find(params[:informacion][:participacion]) if params[:informacion][:participacion].size > 0
    render :partial => "formularios_proyectos_salud", :layout => "only_jquery"
  end

   def formularios_proyectos_dependencias
    @proyectos_seleccionados_dependencias = (params[:proyectos][:dependencias])? params[:proyectos][:dependencias].to_i : Array.new
    @participacion = Participacion.find(params[:informacion][:participacion]) if params[:informacion][:participacion].size > 0
    render :partial => "formularios_proyectos_dependencias", :layout => "only_jquery"
  end


protected

  def valida_evidencias_proyectos(participacion)
     h= Hash.new
     h["valido"] = true
     h["sin_validar"] = Array.new
     current_eje=5
    unless participacion.pescolars.empty?
        h= Hash.new
        h["valido"] = true
        h["sin_validar"] = Array.new
        participacion.pescolars.each do |p|
          if p.materia.include?('MEDIOAMBIENTE')
            contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, participacion.diagnostico_id, 5])
            #### Si la pregunta necesita evidencia ###
            if contador < 1
              h["valido"] = false
              h["sin_validar"] << 5
            end
          end
        if p.materia.include?('SALUD')
          contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, participacion.diagnostico_id, 5])
          #### Si la pregunta necesita evidencia ###
          if contador < 1
            h["valido"] = false
            h["sin_validar"] << 6
          end
        end

        if p.materia.include?('DEPENDENCIAS')
          contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, participacion.diagnostico_id, 5])
          #### Si la pregunta necesita evidencia ###
          if contador < 1
            h["valido"] = false
            h["sin_validar"] << 7
          end
        end
      end
      return h
    else
      return h
  end
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
       @s_dcapacitadoras = multiple_selected(@participacion.dcapacitadoras)
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
