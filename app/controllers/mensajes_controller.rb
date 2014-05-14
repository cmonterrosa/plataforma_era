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
    @mensaje.recibe_id = params[:escuela][:clave_completa]
    @mensaje.envia_id = current_user.id unless @mensaje.envia_id
    @mensaje.activo = true unless @mensaje.activo
    if @mensaje.save
      flash[:notice] = "Mensaje enviado correctamente"
      redirect_to :action => "list"
    else
      flash[:error] = "Su mensaje no pudo enviarse, verifique"
      render :action => "new"
    end
  end

  def show
    @mensaje = Mensaje.find(params[:id])
    if @mensaje.recibe_id == current_user.id
      @mensaje.update_attributes!(:leido_at => Time.now) unless @mensaje.leido_at
    end
  end

end
