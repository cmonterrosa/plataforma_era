class UploadController < ApplicationController
  require_role [:escuela, :admin, :adminplat, :revisor, :enlaceevaluador, :consejero, :equipotecnico]
  
  def index
    @user = current_user
    @uploaded_files = Adjunto.find(:all, :conditions => ["user_id = ?", current_user.id])
    #@uploaded_files = @tramite.adjuntos
  end


  def new
    @uploaded_file = Adjunto.new
  end

  def create
    @uploaded_file =Adjunto.new(params[:adjunto])
    @uploaded_file.user_id = current_user.id if current_user
    if @uploaded_file.save
      flash[:notice] = "archivo cargado correctamente"
       redirect_to :action => "index", :id => @uploaded_file.tramite
    else
       flash[:notice] = "El archivo no fue cargado correctamente"
       render :action => "new"
    end
   
  end

   def destroy
    @uploaded_file = Adjunto.find(params[:id])
    if @uploaded_file.destroy
      flash[:notice] = "Archivo eliminado correctamente"
    else
      flash[:notice] = "No se puedo eliminar, verifique"
    end
    redirect_to :action => "index", :id => @tramite
   end


  def download
    @uploaded_file  = Adjunto.find(params[:id])
    if File.exists?(@uploaded_file.full_path)
      send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
    else
      render :text => "Archivo no existe"
    end
  end

  def view_question
    eje = Eje.find(:first,
                   :select => "ejes.id",
                   :joins => "ejes, proyectos proy, diagnosticos di",
                   :conditions => "ejes.proyecto_id = proy.id and proy.diagnostico_id = di.id and di.id = #{params[:diagnostico]} and ejes.catalogo_eje_id = #{params[:eje]}")

    pregunta = Actividad.find(:first,
                              :select => "actividads.clave, actividads.descripcion, actividads.eje_id",
                              :joins => "actividads, ejes ej, proyectos proy, diagnosticos di",
                              :conditions => "actividads.eje_id = ej.id and ej.proyecto_id = proy.id and proy.diagnostico_id = di.id  and di.id = #{params[:diagnostico]} and actividads.eje_id = #{eje.id} and actividads.clave = 'actividad#{params[:pregunta]}'")
    if pregunta
      render :text => "#{pregunta.descripcion}"
    else
      render :text => "Error al obtener la pregunta, intente mas tarde"
    end
  end


  ################# CARGA DE EVIDENCIAS #############################
  def new_evidencia
    @uploaded_file = Adjunto.new
    @user = current_user
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @eje = params[:eje] if params[:eje]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    return render(:partial => 'new_evidencia', :layout => "only_jquery")
  end

  def list_evidencias
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @eje = params[:eje] if params[:eje]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    @user = current_user
    @evidencias = Adjunto.find(:all, :conditions => ["user_id = ? AND eje_id = ? and numero_pregunta= ?", @user, @eje, @numero_pregunta])
    unless @evidencias.empty?
      return render(:partial => 'show_evidencia', :layout => "only_jquery")
    else
       @uploaded_file = Adjunto.new
       @user = current_user
       return render(:partial => 'new_evidencia', :layout => "only_jquery")
    end
  end
  
  def show_evidencias_por_usuario
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @user = (params[:id]) ? User.find(params[:id]): current_user
    @observaciones_evidencias = (@diagnostico.observaciones_evidencias) ? @diagnostico.observaciones_evidencias : nil if @diagnostico
    @evidencias = (@diagnostico) ? Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ?", @user, @diagnostico.id], :order => "eje_id, numero_pregunta") : Array.new
    unless @evidencias.empty?
      return render(:partial => 'show_todas_evidencias', :layout => "only_jquery")
    else
       @uploaded_file = Adjunto.new
       @user = current_user
       render :text => "<h3>No existen evidencias cargadas</h3>"
       #return render(:partial => 'new_evidencia', :layout => "only_jquery")
    end
  end

  def show_evidencias_avance
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @proyecto = Proyecto.find(:first, :conditions => ["diagnostico_id = ?", @diagnostico.id]) if @diagnostico
    @user = (params[:id]) ? User.find(params[:id]): current_user
    @avance = params[:num_avance] if params[:num_avance]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    if @proyecto
      @observaciones_evidencias = (@proyecto["observaciones_evidencias_avance#{@avance}"]) ? @proyecto["observaciones_evidencias_avance#{@avance}"] : nil
    end
    @evidencias = Adjunto.find(:all, :conditions => ["user_id = ? and avance = ? and proyecto_id = ?", @user.id.to_i , @avance.to_i, @proyecto.id.to_i])
    unless @evidencias.empty?
      return render(:partial => 'show_todas_evidencias_avances', :layout => "only_jquery")
    else
       @uploaded_file = Adjunto.new
       @user = current_user
       render :text => "<h3>No existen evidencias cargadas</h3>"
       #return render(:partial => 'new_evidencia', :layout => "only_jquery")
    end
  end


  def create_evidencia
    @uploaded_file =Adjunto.new(params[:adjunto])
    ##### EJE y PREGUNTA ####
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @eje = params[:eje] if params[:eje]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    @uploaded_file.diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @uploaded_file.eje_id = @eje
    @uploaded_file.numero_pregunta = @numero_pregunta
    @uploaded_file.user_id = current_user.id if current_user
    
    begin
      if @uploaded_file.valid?
          if @uploaded_file.save
            flash[:notice] = "Evidencia cargada correctamente"
            redirect_to :action => "list_evidencias", :diagnostico => @diagnostico, :eje => @eje, :numero_pregunta => @numero_pregunta
          end
      else
         @errores = @uploaded_file.errors
         return render(:partial => 'carga_evidencia_error', :layout => "only_jquery")
      end
    rescue ActiveRecord::RecordInvalid => invalid
        @errores = invalid.record.errors
        return render(:partial => 'carga_evidencia_error', :layout => "only_jquery")
    end
  end
 

  def destroy_evidencia
    if @uploaded_file = Adjunto.find(params[:id])
      @eje = @uploaded_file.eje_id
      @numero_pregunta = @uploaded_file.numero_pregunta
      @diagnostico = @uploaded_file.diagnostico_id
    end
    if @uploaded_file.destroy
      #return render(:partial => 'eliminar_evidencia_exitosa', :layout => "only_jquery")
      flash[:notice] = "Evidencia eliminada correctamente"
      render = (params[:dashboard]) ? {:action => "dashboard", :controller => "admin", :diagnostico=> params[:diagnostico_id], :id => params[:user_id]} : {:action => "list_evidencias", :diagnostico => @diagnostico, :eje => @eje, :numero_pregunta => @numero_pregunta}
      redirect_to render
    else
      return render(:partial => 'eliminar_evidencia_error', :layout => "only_jquery")
    end
  end

  def destroy_evidencia_avance
    if @uploaded_file = Adjunto.find(params[:id])
      @eje = @uploaded_file.eje_id
    end
    if @uploaded_file.destroy
      flash[:notice] = "Evidencia eliminada correctamente"
      @user = current_user
      @proyecto = params[:proyecto] if params[:proyecto]
      @eje = params[:eje] if params[:eje]
      @num_avance = params[:num_avance] if params[:num_avance]
      @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
      redirect_to :action => "list_evidencias_avance", :proyecto => @proyecto, :eje => @eje, :num_avance => @num_avance, :numero_pregunta => @numero_pregunta
    else
      return render(:partial => 'eliminar_evidencia_error', :layout => "only_jquery")
    end
  end

   ################# CARGA DE EVIDENCIAS AVANCES#############################
  def new_evidencia_avance
    @uploaded_file = Adjunto.new
    @user = current_user
    @eje = params[:eje] if params[:eje]
    @proyecto = params[:proyecto] if params[:proyecto]
    @num_avance = params[:num_avance] if params[:num_avance]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    return render(:partial => 'new_evidencia_avance', :layout => "only_jquery")
  end

  def list_evidencias_avance
    @user = current_user
    @proyecto = params[:proyecto] if params[:proyecto]
    @eje = params[:eje] if params[:eje]
    @num_avance = params[:num_avance] if params[:num_avance]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    @evidencias = Adjunto.find(:all, :conditions => ["user_id = ? AND eje_id = ? and numero_pregunta = ? and avance = ? and proyecto_id = ?", @user.id, @eje, @numero_pregunta, @num_avance, @proyecto])
    unless @evidencias.empty?
      return render(:partial => 'show_evidencia_avance', :layout => "only_jquery", :num_avance => @num_avance, :numero_pregunta => @numero_pregunta, :eje => @eje, :proyecto => @proyecto)
    else
       @uploaded_file = Adjunto.new
       @user = current_user
       return render(:partial => 'new_evidencia_avance', :layout => "only_jquery" , :num_avance => @num_avance, :numero_pregunta => @numero_pregunta, :eje => @eje, :proyecto => @proyecto)
    end
  end



  def create_evidencia_avance
    @uploaded_file =Adjunto.new(params[:adjunto])
    ##### EJE y PREGUNTA ####
    @proyecto = params[:proyecto] if params[:proyecto]
    @eje = params[:eje] if params[:eje]
    @num_avance = params[:num_avance] if params[:num_avance]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    @uploaded_file.proyecto = Proyecto.find(params[:proyecto]) if params[:proyecto]
    @uploaded_file.eje_id = @eje.to_i
    @uploaded_file.avance = @num_avance.to_i
    @uploaded_file.numero_pregunta = @numero_pregunta.to_i
    @uploaded_file.user_id = current_user.id if current_user
    begin
      if @uploaded_file.save
        flash[:notice] = "Evidencia cargada correctamente"
        redirect_to :action => "list_evidencias_avance", :proyecto => @proyecto, :eje => @eje, :num_avance => @num_avance, :numero_pregunta => @numero_pregunta
      else
        @errores = @uploaded_file.errors.full_messages
        return render(:partial => 'carga_evidencia_error', :layout => "only_jquery")
      end
    rescue ActiveRecord::RecordInvalid => invalid
      @errores = invalid.record.errors
      return render(:partial => 'carga_evidencia_error', :layout => "only_jquery")
    end
   end

#  def destroy_evidencia_avance
#    if @uploaded_file = Adjunto.find(params[:id])
#      @eje = @uploaded_file.eje_id
#      @num_avance, @avance = params[:num_avance] if params[:num_avance]
#      @proyecto = @uploaded_file.proyecto_id
#      @proyecto_obj = Proyecto.find(@proyecto)
#      @diagnostico = @proyecto_obj.diagnostico if @proyecto_obj
#      @user = User.find(params[:user]) if params[:user]
#      @avance ||= params[:avance] if params[:avance]
#    end
#    if @uploaded_file.destroy
#      #return render(:partial => 'eliminar_evidencia_exitosa', :layout => "only_jquery")
#      flash[:notice] = "Evidencia eliminada correctamente"
#      @url_regreso =  {:action => "show_evidencias_avance", :id => @user, :diagnostico => @diagnostico, :avance => @avance}
#      redirect_to @url_regreso
#      #redirect_to :action => "show_evidencias_avance", :proyecto => params[:proyecto], :eje => @eje, :num_avance => @num_avance
#    else
#      return render(:partial => 'eliminar_evidencia_error', :layout => "only_jquery")
#    end
#  end

  def validar
     @adjunto = Adjunto.find(params[:id])
     @diagnostico = Diagnostico.find(params[:diagnostico])
     @user = User.find(params[:user])
     @avance = params[:avance] if params[:avance]
    (@adjunto.update_attributes!(:validado => true, :user_validado => current_user.id))? flash[:notice] = "Evidencia se validó correctamente" : flash[:error] = "No se pudo validar, intente más tarde"
     ### Validamos si la peticion viene del monitor de evaluacion ###
     @url_regreso = (params[:dashboard]) ? {:action => "dashboard", :controller => "admin", :diagnostico=> @diagnostico, :id => @user} : nil
     @url_regreso ||= (params[:dashboard_proyecto]) ? {:action => "dashboard_proyecto", :controller => "admin", :diagnostico=> @diagnostico, :id => @user, :proyecto => params[:proyecto]} : nil
     @url_regreso ||= (@avance)? {:action => "show_evidencias_avance", :id => @user, :diagnostico => @diagnostico, :avance => @avance} : {:action => "show_evidencias_por_usuario", :id => @user, :diagnostico => @diagnostico}
    redirect_to @url_regreso
  end

  def invalidar
     @adjunto = Adjunto.find(params[:id])
     @diagnostico = Diagnostico.find(params[:diagnostico])
     @user = User.find(params[:user])
     @avance = params[:avance] if params[:avance]
     @url_regreso = (params[:dashboard]) ? {:action => "dashboard", :controller => "admin", :diagnostico=> @diagnostico, :id => @user} : nil
     @url_regreso ||= (params[:dashboard_proyecto]) ? {:action => "dashboard_proyecto", :controller => "admin", :diagnostico=> @diagnostico, :id => @user, :proyecto => params[:proyecto]} : nil
     @url_regreso ||= (@avance)? {:action => "show_evidencias_avance", :id => @user, :diagnostico => @diagnostico, :avance => @avance} : {:action => "show_evidencias_por_usuario", :id => @user, :diagnostico => @diagnostico}
    (@adjunto.update_attributes!(:validado => false, :user_validado => current_user.id))? flash[:notice] = "Evidencia se invalidó correctamente" : flash[:error] = "No se pudo validar, intente más tarde"
    redirect_to @url_regreso
  end

  def reporte_evidencias_diagnostico
    @diagnostico = Diagnostico.find(params[:diagnostico])
    @user = User.find(params[:id]) if params[:id]
    @user ||= User.find(params[:user]) if params[:user]
    @observaciones_evidencias = params[:diagnosticos][:observaciones_evidencias] if params[:diagnosticos]
    @observaciones_evidencias ||= @diagnostico.observaciones_evidencias
    @diagnostico.update_attributes!(:observaciones_evidencias => @observaciones_evidencias, :validacion_evidencias => true) if @observaciones_evidencias
    @evidencias = Adjunto.find(:all, :conditions => ["validado = ? AND user_id = ? AND diagnostico_id = ?", false, @user, @diagnostico])
  end

  def reporte_evidencias_avances
    @proyecto = Proyecto.find(params[:proyecto])
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @avance = params[:avance] if params[:avance]
    @url_field = "observaciones_evidencias_avance#{@avance}"
    @url_validacion = "validacion_evidencias_avance#{@avance}"
    @user = User.find(params[:id]) if params[:id]
    @user ||= User.find(params[:user]) if params[:user]
    @recibe = (@user) ? @user : User.find_by_escuela_id(@diagnostico.escuela_id)
    @observaciones_evidencias = params[:proyectos][:observaciones_evidencias] if params[:proyectos]
    @observaciones_evidencias ||= @proyecto[@url_field]
    @proyecto.update_attributes!(@url_field => @observaciones_evidencias, @url_validacion => true) if @observaciones_evidencias
    @evidencias = Adjunto.find(:all, :conditions => ["validado = ? AND user_id = ? AND avance = ?", false, @user, @avance])

  end


end
