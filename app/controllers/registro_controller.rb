class RegistroController < ApplicationController
#  layout 'era'
  layout :set_layout
  before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => :save
#  require_role [:escuela, :coordinador, :adminplat, :admin]
  
  def index
    redirect_to :action => "new_or_edit"
  end

  def index
    if current_user.has_role?("directivo")
      redirect_to :action => "show_escuelas", :controller => "admin"
    else
      ## Si es una escuela #####
       if current_user
          if @escuela = Escuela.find_by_clave(current_user.login.upcase)
              redirect_to :action => "new_or_edit", :escuela => {:clave => @escuela.clave}, :method => :get
          end
       end
       @escuela ||= Escuela.new
    end
  end
  
  def new_or_edit
    unless params[:escuela][:clave].size > 4 && @escuela = Escuela.find_by_clave(params[:escuela][:clave])
      flash[:error] = "No existe escuela"
      redirect_to :controller => "home"
    else
      @select_ce = selected(@escuela.categoria_escuela) if @escuela.categoria_escuela
      @s_programas = multiple_selected_id(@escuela.programas) if @escuela.programas
      if @escuela.registro_completo || @escuela.estatu.jerarquia > Estatu.find_by_clave("esc-datos").jerarquia
          flash[:warning] = "La escuela ha completado el registro con anterioridad"
          redirect_to :action => "menu_reportes", :id => @escuela
      end
    end
   
  end

  def menu_reportes
    @escuela = Escuela.find(params[:id])
  end

  def save
    @escuela = Escuela.find_by_clave(params[:clave]) if params[:clave]
    @escuela ||= Escuela.new
    @escuela.categoria_desc = '' unless params[:escuela][:categoria_desc]
    @escuela.programa_desc = '' unless params[:escuela][:programa_desc]
    @escuela.update_attributes(params[:escuela])
    @escuela.categoria_escuela = CategoriaEscuela.find_by_clave(params[:escuela][:categoria_escuela_id]) if params[:escuela][:categoria_escuela_id]

    if params[:programas]
      @programas = []
      params[:programas].each { |op| @programas << Programa.find_by_clave(op)  }
      @escuela.programas = Programa.find(@programas)
    else
      @escuela.programas.delete_all
    end

    @escuela.registro_completo = true
    if @escuela.save
      @escuela.update_bitacora!("esc-datos", current_user)
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :action => "menu_reportes", :id => @escuela
    else
      flash[:error] = "No se puedo guardar, verifique el registro"
      render :action => "new_or_edit"
    end
  end

  def show_info_escuela
    if params[:escuela_clave].size > 4
      @escuela = Escuela.find_by_clave(params[:escuela_clave])
      return render(:partial => 'list_by_user', :layout => false) if @escuela && request.xhr?
    end
  end

  def formato_registro
    @clave, pdf = params[:id].split(".")
    unless @clave.size > 4 && @escuela = Escuela.find_by_clave(@clave)
      flash[:error] = "Error al generar reporte de registro"
      redirect_to :controller => "home"
    end
    @select_ce = selected(@escuela.categoria_escuela) if @escuela.categoria_escuela
    @s_programas = multiple_selected_id(@escuela.programas) if @escuela.programas
  end

  def reporte_final
    @user= User.find(params[:id])
    @escuela = @user.escuela if @user
    unless @escuela.ever_had_status?("avance2")
       flash[:notice] = "La escuela aún no ha concluido el proceso de certificación"
       redirect_to :controller => "home"
    end
  end
  
  private

  def set_layout
    (action_name == 'formato_registro' || action_name == 'reporte_final')? 'reporte' : 'era2014'
  end

end
