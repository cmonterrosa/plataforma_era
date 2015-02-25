class ParticipacionsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @participacion = @diagnostico.participacion || Participacion.new
    @s_dcapacitadoras = multiple_selected(@participacion.dcapacitadoras)
    ### Proyectos medio ambiente ###
    @s_proyectos_ma =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, 'MEDIOAMBIENTE'])
    @proyectos_seleccionados_ambiente = ( @s_proyectos_ma.empty?)? 0: @s_proyectos_ma.size
  end

  def save
    @participacion = Participacion.find(params[:id]) if params[:id]
    @participacion ||= Participacion.new
    @participacion.update_attributes(params[:participacion])
    @diagnostico = @participacion.diagnostico = Diagnostico.find(params[:diagnostico])

#    validador = verifica_evidencias(@diagnostico,5)
     validador="valido"

     #if validador["valido"]
     if validador == "valido"
      #@participacion.proy_escolares_ma_desc = '' unless params[:participacion][:proy_escolares_ma_desc]
      #@participacion.proy_escolares_salud_desc = '' unless params[:participacion][:proy_escolares_salud_desc]
      #@participacion.act_salud_ma_desc = '' unless params[:participacion][:act_salud_ma_desc]
      #@participacion.act_dep_gobierno_desc = '' unless params[:participacion][:act_dep_gobierno_desc]
    
      if @participacion.save

        ## Dependencias Capacitadoras ##
        @capacitadoras = ( params[:capacitacion]) ?  params[:capacitacion] : Array.new
        @capacitadoras.each do |c|
            dc = Dcapacitadora.find_by_clave(c.last)
            capacitacion = CapacitacionPadre.find_by_dcapacitadora_id(dc.id) if dc
            capacitacion ||= CapacitacionPadre.new
            capacitacion.participacion_id  ||= @participacion.id
            capacitacion.dcapacitadora_id ||= dc.id if dc
            capacitacion.numero_capacitaciones =(params[:capacitadora]["#{dc.clave}"]) ?  params[:capacitadora]["#{dc.clave}"] : nil
            (capacitacion.numero_capacitaciones) ? capacitacion.save : nil
        end
        guardar_proyectos(params[:pescolaresambiente], "MEDIOAMBIENTE", @participacion) if params[:pescolaresambiente]
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else
        flash[:evidencias] = @participacion.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end

  def formularios_proyectos_ambientes
    @proyectos_seleccionados_ambiente = (params[:proyectos][:ambiente])? params[:proyectos][:ambiente].to_i : Array.new
    @participacion = Participacion.find(params[:informacion][:participacion]) if params[:informacion][:participacion]
    render :partial => "formularios_proyectos_ambientes", :layout => "only_jquery"
  end

  protected

  #### Funcion que guarda los proyectos escolares por tipo #####
  def guardar_proyectos(parametros, tipo, participacion)
        if @proyectos = parametros
        ids_olds =  Pescolar.find(:all, :conditions => ["participacion_id = ? AND materia= ?", @participacion.id, tipo]).map{|i|i.id}
          (1..12).each do |numero|
            if @proyectos.has_key?("nombre_#{numero}")
                  Pescolar.create(:participacion_id => participacion.id, :materia => tipo, :descripcion => @proyectos["descripcion_#{numero}"], :nombre => @proyectos["nombre_#{numero}"] )
            end
          end
          Pescolar.find(ids_olds).each do |p| p.destroy end unless ids_olds.empty?
        end
  end


end
