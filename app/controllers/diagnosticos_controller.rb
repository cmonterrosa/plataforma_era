class DiagnosticosController < ApplicationController
  before_filter :login_required

  def index

  end

  def new_or_edit
    unless Diagnostico.find_by_escuela_id(Escuela.find_by_clave(current_user.login.upcase))
      @diagnostico = Diagnostico.new(:escuela_id => Escuela.find_by_clave(current_user.login.upcase).id)
      (@diagnostico.save)? flash[:notice] = "Bienvenido a la captura del diagnóstico" : flash[:error] = "No se pudo crear objeto, verifique"
    end
    redirect_to :action => "index"
  end

end
