class CombosController < ApplicationController
  def get_ahorradores
    @ahorradores = 0..params[:huella_total_focos].to_i
    return render(:partial => 'ahorradores', :layout => false) if request.xhr?
    #render :text => "Total de focos:"
  end

  def get_clave_escuela
    @escuela = Escuela.find(:first, :conditions => ["clave = ?", params[:escuela_clave]]) if params[:escuela_clave].size > 6
    if @escuela
      return render(:partial => 'escuela', :layout => false) if request.xhr?
    else
      render :text => "<h4 style='color:red;'>Escuela no existe, escriba una clave válida</h4>"
    end
  end

end
