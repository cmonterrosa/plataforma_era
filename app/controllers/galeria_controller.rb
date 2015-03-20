class GaleriaController < ApplicationController
  def global
    @adjuntos = Adjunto.find(:all, :conditions => ["file_type = ?", "image/jpeg"], :limit => 32)
    @nombre = "Galería global"
     unless @adjuntos
       flash[:notice] = "No existen imagenes"
       redirect_to :controller => "home"
       else
        render :partial => "galeria", :layout => "era2014"
     end
  end

   def por_escuela
     @escuela = Escuela.find(params[:id]) if params[:id]
     @nombre = @escuela.nombre
     @user = User.find_by_escuela_id(@escuela) if @escuela
     @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? AND file_type = ?", @user.id, "image/jpeg"])
     unless @adjuntos
       flash[:notice] = "No existen imagenes"
       redirect_to :controller => "home"
     else
       render :partial => "galeria", :layout => "era2014"
     end
   end

end
