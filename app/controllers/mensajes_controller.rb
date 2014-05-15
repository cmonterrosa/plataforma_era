class MensajesController < ApplicationController
  before_filter :login_required

  
  
  def index
    redirect_to :action => "list"
  end

  def list
  end

  def enviados
    @enviados = Mensaje.find(:all, :conditions => ["envia_id = ?", current_user.id])
  end
  
  def recibidos
    @recibidos = Mensaje.find(:all, :conditions => ["recibe_id = ?", current_user.id])
  end

  def new
    @mensaje = Mensaje.new
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
    @mensaje_respuesta = Mensaje.new
    if @mensaje.recibe_id == current_user.id
      @mensaje.update_attributes!(:leido_at => Time.now) unless @mensaje.leido_at
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

end
