class UploadController < ApplicationController
  require_role [:escuela, :admin]
  
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
    send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
  end


  ################# CARGA DE EVIDENCIAS #############################
  def new_evidencia
    @uploaded_file = Adjunto.new
    @user = current_user
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @eje = params[:eje] if params[:eje]
    @numero_pregunta = params[:numero_pregunta] if params[:numero_pregunta]
    @evidencias = Adjunto.find(:all, :conditions => ["user_id = ? AND eje_id = ? and numero_pregunta= ?", @user, @eje, @numero_pregunta])
    unless @evidencias.empty?
      return render(:partial => 'show_evidencia', :layout => "only_jquery")
    else
       return render(:partial => 'new_evidencia', :layout => "only_jquery")
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
    if @uploaded_file.save
      return render(:partial => 'carga_evidencia_exitosa', :layout => "only_jquery")
    else
       return render(:partial => 'carga_evidencia_error', :layout => "only_jquery")
    end
  end

  def destroy_evidencia
    @uploaded_file = Adjunto.find(params[:id])
    if @uploaded_file.destroy
      return render(:partial => 'eliminar_evidencia_exitosa', :layout => "only_jquery")
    else
      return render(:partial => 'eliminar_evidencia_error', :layout => "only_jquery")
    end
  end
end
