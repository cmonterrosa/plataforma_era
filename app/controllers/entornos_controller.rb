class EntornosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @entorno = @diagnostico.entorno || Entorno.new
    @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
    @escuela = Escuela.find_by_clave(current_user.login)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
    end
    
  end

  def save
    @entorno = Entorno.find(params[:id]) if params[:id]
    @entorno ||= Entorno.new
    @entorno.update_attributes(params[:entorno])
    @diagnostico = @entorno.diagnostico = Diagnostico.find(params[:diagnostico])
    
    validador = verifica_evidencias(@diagnostico,2)
    
    if validador["valido"]
      if params[:acciones]
        @acciones = []
        params[:acciones].each { |op| @acciones << Accione.find_by_clave(op)  }
        @entorno.acciones = Accione.find(@acciones)
      else
        @entorno.acciones.delete_all
      end

      if @entorno.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :controller => "diagnosticos"
      else

        @escuela = Escuela.find_by_clave(current_user.login)
        if @escuela.nivel_descripcion == "BACHILLERATO"
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
        else
          @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
        end

        @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
        flash[:evidencias] = @entorno.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      @escuela = Escuela.find_by_clave(current_user.login)
      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
      else
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
      end
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end
  
end
