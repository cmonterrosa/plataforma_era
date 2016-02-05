class PublicController < ApplicationController


  def index_report
    ## Especificamos DB conection ###
    Nivel.establish_connection(RAILS_ENV)
    Escuela.establish_connection(RAILS_ENV)
    @niveles = Nivel.find(:all, :conditions => ["descripcion <> ?", "OTRO"])
    @generaciones = Generacion.find(:all, :order => "ciclo_id DESC")
    @sostenimientos = Escuela.find(:all, :select => "sostenimiento", :group => "sostenimiento")
  end

  def select_parametros
    @niveles = Nivel.find(:all)
    @ciclos = Ciclo.find(:all)
  end

  def get_detalle_estadisticas
    if (params[:detalle][:ciclo_id] && params[:detalle][:ciclo_id].size > 0) && (params[:detalle][:sostenimiento] && params[:detalle][:sostenimiento].size > 0) && (params[:niveles] && !params[:niveles].empty?)
      @ciclo = Ciclo.find(params[:detalle][:ciclo_id])
      @ciclo ||= Ciclo.find_by_descripcion(GENERACION) if GENERACION
      @generacion = Generacion.find(:first, :conditions => ["ciclo_id = ?", @ciclo], :order => "ciclo_id DESC")
      @sostenimientos = Escuela.find(:all, :conditions => ["sostenimiento = ?", params[:detalle][:sostenimiento]], :select => "sostenimiento", :group => "sostenimiento")
      @sostenimiento ||= params[:detalle][:sostenimiento] if params[:detalle][:sostenimiento]
      @sostenimientos ||= Escuela.find(:all, :select => "sostenimiento", :group => "sostenimiento")
      @niveles_ids = []
      @niveles_descripcions = []
      params[:niveles].each_key { |id|
        @niveles_ids << id
        @niveles_descripcions << Nivel.find_by_id(id).descripcion if Nivel.exists?(id)
      }
      @niveles = Nivel.find(:all, :conditions => ["id in (?)", @niveles_ids]) unless @niveles_ids.empty?
      @niveles ||= Nivel.find(:all, :conditions => ["descripcion <> ?", "OTRO"])
      @descripcion_sostenimiento = params[:detalle][:sostenimiento] if params[:detalle][:sostenimiento]
      render :partial => "report_by_niveles_libre", :layout => "only_jquery"
    else
      render :text => ""
    end
  end



  def report_by_niveles_libre
    ## Especificamos DB conection ###
    Nivel.establish_connection(RAILS_ENV)
    Escuela.establish_connection(RAILS_ENV)
    #@niveles = Nivel.find(:all, :conditions => ["descripcion <> ?", "OTRO"])
    @niveles = Nivel.find(:all)
    @generacion= Generacion.find(params[:generacion]) if params[:generacion]
    @sostenimiento = "TODOS" if params[:sostenimiento] && params[:sostenimiento] == "all"
    @sostenimiento ||= params[:sostenimiento] if params[:sostenimiento]
    @nivel = 'EM' if params[:token] && params[:token] == "EM"
    @descripcion_sostenimiento = (@sostenimiento == "TODOS") ? "TODOS LOS SOSTENIMIENTOS" : "SOSTENIMIENTO #{@sostenimiento}"
    render :partial => "report_by_niveles_libre", :layout => "only_jquery"
  end

  def list_esc_nivel
    @nivel_descripcion = params[:nivel_descripcion]
    @nivel = Nivel.find_by_descripcion(@nivel_descripcion)
    @generacion= Generacion.find(params[:generacion]) if params[:generacion]
    @sostenimiento = "TODOS" if params[:sostenimiento] && params[:sostenimiento] == "all"
    @sostenimiento ||= params[:sostenimiento] if params[:sostenimiento]
    @descripcion_sostenimiento = (@sostenimiento == "TODOS") ? "TODOS LOS SOSTENIMIENTOS" : "SOSTENIMIENTO #{@sostenimiento}"
    if @sostenimiento == "TODOS"
        @escuelas = User.find(:all, :select => "users.login, users.id as user_id, e.*",
                    :joins => "users, escuelas e, escuelas_generacions eg, generacions g",
                   :conditions => ["users.login=e.clave AND e.id=eg.escuela_id AND eg.generacion_id=g.id AND g.id = ? AND (users.blocked is NULL OR  users.blocked !=1) and e.estatu_id > 0 and e.nivel_id = ?", @generacion, @nivel.id],
                   :order => "e.modalidad").paginate(:page => params[:page], :per_page => 25)
    else
      @escuelas = User.find(:all, :select => "users.login, users.id as user_id, e.*",
                    :joins => "users, escuelas e, escuelas_generacions eg, generacions g",
                   :conditions => ["users.login=e.clave AND e.id=eg.escuela_id AND eg.generacion_id=g.id AND g.id = ? AND (users.blocked is NULL OR  users.blocked !=1) and e.estatu_id > 0 and e.nivel_id = ? AND e.sostenimiento = ?", @generacion, @nivel.id, @sostenimiento],
                   :order => "e.modalidad").paginate(:page => params[:page], :per_page => 25)  
    end


   end

end
