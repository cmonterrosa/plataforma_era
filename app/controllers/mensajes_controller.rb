class MensajesController < ApplicationController
  before_filter :login_required

  
  
  def index
    redirect_to :action => "list"
  end

  def list
  end

  def enviados
    @enviados = Mensaje.find(:all, :conditions => ["envia_id = ?", current_user.id], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def recibidos
    @recibidos = Mensaje.find(:all, :conditions => ["recibe_id = ?", current_user.id], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def new
    if current_user.has_role?("esys") || current_user.has_role?("revisor") || current_user.has_role?("coordinador") || current_user.has_role?("nivel") || current_user.login == "esys"
      @mensaje = Mensaje.new
      @destinatario = User.find(params[:recibe_id]) if params[:recibe_id]
      @escuela = Escuela.find_by_clave(@destinatario.login) if @destinatario
    else
      if current_user.has_role?("equipotecnico") || current_user.has_role?("consejero")
        redirect_to :action => "new_to_equipo_and_consejeros"
      else
        redirect_to :action => "new_to_administrador"
      end
    end
  end

  ##### Mensaje a administrador #####

  def new_to_administrador
    @mensaje = Mensaje.new
    @destinatario = User.find_by_login("esys")
    unless @destinatario
      flash[:error] = "No existe ningun usuario administrador"
      redirect_to :controller => "home"
    end
  end

  def save_to_administrador
    @mensaje = Mensaje.new(params[:mensaje])
    usuario = User.find(params[:destinatario]) if params[:destinatario]
    @mensaje.recibe_id = usuario.id if usuario
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    if usuario && @mensaje.save
      flash[:notice] = "Mensaje enviado correctamente"
      redirect_to :action => "list"
    else
      flash[:error] = "Su mensaje no pudo enviarse, inserte un destinatario"
      render :action => "new"
    end
 end


  ### Mensajes entre consejeros y equipo tecnico ####
  
  def new_to_equipo_and_consejeros
    @mensaje = Mensaje.new
    @destinatarios = Role.find_by_name("equipotecnico").todos_usuarios
    @destinatarios += Role.find_by_name("consejero").todos_usuarios
    @destinatarios = @destinatarios.sort{|a,b| a.nombre <=> b.nombre}
  end

  def save_to_consejeros
    @mensaje = Mensaje.new(params[:mensaje])
    usuario = (params[:destinatario][:escuela] == "SI")? User.find_by_login(params[:escuela][:clave]) :   User.find(params[:mensaje][:recibe_id])
    usuario ||= User.find(params[:mensaje][:recibe_id]) if params[:mensaje][:recibe_id]
    @mensaje.recibe_id = usuario.id if usuario
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    if usuario && @mensaje.save
      flash[:notice] = "Mensaje enviado correctamente"
      redirect_to :action => "list"
    else
      @destinatarios = Role.find_by_name("equipotecnico").todos_usuarios
      @destinatarios += Role.find_by_name("consejero").todos_usuarios
      @destinatarios = @destinatarios.sort{|a,b| a.nombre <=> b.nombre}
      flash[:error] = "Su mensaje no pudo enviarse, inserte un destinatario"
      render :action => "new_to_equipo_and_consejeros"
    end
 end



  def save
    @mensaje = Mensaje.new(params[:mensaje])
    clave, nombre = params[:escuela][:clave_completa].split("|") if params[:escuela][:clave_completa]
    usuario = User.find_by_login(clave) if clave
    @mensaje.recibe_id = usuario.id if usuario
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    if usuario && @mensaje.save
      flash[:notice] = "Mensaje enviado correctamente"
      redirect_to :action => "list"
    else
      flash[:error] = "Su mensaje no pudo enviarse, inserte un destinatario"
      render :action => "new"
    end
  end

  def show
    @mensaje = Mensaje.find(params[:id])
    if @mensaje && (@mensaje.envia_id == current_user.id || @mensaje.recibe_id == current_user.id || (current_user.has_role?("adminplat") || current_user.has_role?("admin")))
       @mensaje = Mensaje.find(params[:id])
       @mensaje_respuesta = Mensaje.new
    if @mensaje.recibe_id == current_user.id
      @mensaje.update_attributes!(:leido_at => Time.now) unless @mensaje.leido_at
    end
    else
      flash[:error] = "No tiene privilegios de visualizar este mensaje"
      redirect_to :action => "list"
    end
    end

  def responder
    @mensaje_respuesta = Mensaje.new
    @mensaje_respuesta.recibe_id = params[:recibe_id]
    @destinatario = User.find(params[:recibe_id]) if params[:recibe_id]
  end

  def save_respuesta
    @mensaje_respuesta = Mensaje.new(params[:mensaje])
    @mensaje_respuesta.recibe_id = params[:destinatario] if params[:destinatario]
    @mensaje_respuesta.envia_id = current_user.id unless @mensaje_respuesta.envia_id
    @mensaje_respuesta.activo = true unless @mensaje_respuesta.activo
    @mensaje_respuesta.asunto = "RE: " + @mensaje_respuesta.asunto
    if params[:destinatario] && @mensaje_respuesta.save
      flash[:notice] = "Mensaje respondido correctamente"
      redirect_to :action => "list"
    else
      flash[:error] = "Su mensaje no pudo enviarse, inserte un destinatario"
      render :action => "new"
    end
  end

  def destroy
    @mensaje = Mensaje.find(params[:id])
    if @mensaje.destroy
      flash[:notice] = "Mensaje eliminado correctamente"
    else
      flash[:error] = "Mensaje no se pudo eliminar, verifique"
    end
    redirect_to :action => "list"
  end


  ###### NOTIFICACIONES ESPECIFICAS DEL SISTEMA #########
  def send_reporte_evidencias_diagnostico
    @mensaje = Mensaje.new(params[:mensaje])
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @mensaje.recibe_id =  (params[:recibe_id]) ? User.find(params[:recibe_id]).id : nil
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    @mensaje.asunto = "Comentarios y correcciones de evidencias del diagnóstico, haga click en la liga en color rojo"
    @mensaje.descripcion = @diagnostico.observaciones_evidencias if @diagnostico
    @mensaje.url_notificacion_sistema = "#{url_for :host => SITE_URL, :action => "reporte_evidencias_diagnostico", :controller => 'upload', :diagnostico => params[:diagnostico], :id => params[:user]}"
    if @mensaje.save
        ##### Cambiamo estatus para marcar que el diagnostico ha sido revisado ####
        @diagnostico.escuela.update_bitacora!("diag-rev", current_user) if @diagnostico.escuela
        flash[:notice] = "Se envío reporte de evidencias del diagnóstico a la escuela correspondiente"
        redirect_to :controller => "admin", :action => "menu_escuela", :id => params[:user]
    end
  end

    def send_reporte_evidencias_avance
    @mensaje = Mensaje.new(params[:mensaje])
    @diagnostico = Diagnostico.find(params[:diagnostico]) if params[:diagnostico]
    @proyecto = Proyecto.find_by_diagnostico_id(@diagnostico.id) if @diagnostico
    @avance = params[:avance] if params[:avance]
    @mensaje.recibe_id =  (params[:recibe_id]) ? User.find(params[:recibe_id]).id : nil
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    @mensaje.asunto = "Comentarios y correcciones de evidencias del avance #{@avance}, haga click en la liga en color rojo"
    @mensaje.descripcion = @diagnostico.observaciones_evidencias if @diagnostico
    @mensaje.url_notificacion_sistema = "#{url_for :host => SITE_URL, :action => "reporte_evidencias_avance", :controller => 'upload', :avance => @avance, :diagnostico => params[:diagnostico], :id => params[:user], :proyecto => @proyecto}"
    if @mensaje.save
        ##### Cambiamo estatus para marcar que el diagnostico ha sido revisado ####
       # @diagnostico.escuela.update_bitacora!("diag-rev", current_user) if @diagnostico.escuela
        flash[:notice] = "Se envío reporte de evidencias del avance #{@avance} a la escuela correspondiente"
        redirect_to :controller => "admin", :action => "menu_escuela", :id => params[:user]
    end
  end

end
