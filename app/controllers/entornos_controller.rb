class EntornosController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
  
  def new_or_edit
    @diagnostico = Diagnostico.find(params[:id]) if params[:id]
    @diagnostico ||= Diagnostico.new
    @entorno = @diagnostico.entorno || Entorno.new
    @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
    @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
    @escuela = Escuela.find_by_clave(current_user.login)
    if @escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC03')"])
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00', 'AC01')"])
    end
    
  end

  def save
    @entorno = Entorno.find(params[:id]) if params[:id]
    @entorno ||= Entorno.new
    @entorno.update_attributes(params[:entorno])
    @diagnostico = @entorno.diagnostico = Diagnostico.find(params[:diagnostico])

    validador = verifica_evidencias(@diagnostico,2)
    
    if validador["valido"]
      @entorno.arboles_nativos_num = @entorno.arboles_nativos_desc = nil if @entorno.arboles_nativos == "NO"
      @entorno.arboles_no_nativos_num = @entorno.arboles_no_nativos_desc = nil if @entorno.arboles_no_nativos == "NO"
      @entorno.escuela_reforesta_num = nil if @entorno.escuela_reforesta == "NO"
      @entorno.superficie_terreno_escuela_av = nil if @entorno.superficie_terreno_escuela.to_i == 0

      
      if params[:acciones]
        @acciones = []
        params[:acciones].each { |op| @acciones << Accione.find_by_clave(op)  }
        @entorno.acciones = Accione.find(@acciones)
      else
        @entorno.acciones.delete_all
      end

#      EscuelasEspacio.delete_all(@entorno.id) if @entorno
      if params[:espacios]
        params[:espacios].each_key do |esp|
          espacio = Espacio.find(esp)
          espacio_escuela = EscuelasEspacio.find_by_espacio_id(esp)
          espacio_escuela ||= EscuelasEspacio.new
          espacio_escuela.entorno_id = @entorno
          espacio_escuela.espacio_id = espacio.id
          espacio_escuela.numero = params[:"#{espacio.clave}"].to_i
          @entorno.escuelas_espacios << espacio_escuela
        end
        
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
        @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
        
        flash[:evidencias] = @entorno.errors.full_messages.join(", ")
        render :action => "new_or_edit"
      end
    else
      @escuela = Escuela.find_by_clave(current_user.login)
      @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
      @s_espacios = multiple_selected_espacios(@entorno.escuelas_espacios) if @entorno.escuelas_espacios
      if @escuela.nivel_descripcion == "BACHILLERATO"
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
      else
        @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
      end
      @entorno.escuelas_espacios.delete_all
      errores = validador["sin_validar"].join(" y ")
      flash[:evidencias] = "Cargue archivos para la(s) pregunta(s): #{errores}"
      render :action => "new_or_edit"
    end
  end
  
end
