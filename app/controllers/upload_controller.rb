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

end
