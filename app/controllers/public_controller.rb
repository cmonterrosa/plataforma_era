class PublicController < ApplicationController


  def index_report
    ## Especificamos DB conection ###
    Nivel.establish_connection(RAILS_ENV)
    Escuela.establish_connection(RAILS_ENV)
    @niveles = Nivel.find(:all, :conditions => ["descripcion <> ?", "OTRO"])
    @generaciones = Generacion.find(:all, :order => "ciclo_id DESC")
    @sostenimientos = Escuela.find(:all, :select => "sostenimiento", :group => "sostenimiento")
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
