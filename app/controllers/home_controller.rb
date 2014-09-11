class HomeController < ApplicationController
  
  #before_filter :dispatch

  
  def index
    dispatch
  end

  def certificacion_esys
   
  end

  def certificacion_manual

  end

  def certificacion_diagnostico

  end

  def certificacion_proyecto
    redirect_to :action => "certificacion_manual"
  end

  def certificacion_evidencias
       redirect_to :action => "certificacion_manual"
  end

  def certificacion_resultado
     redirect_to :action => "certificacion_manual"
  end

  def certificacion_avances
    redirect_to :action => "certificacion_manual"
  end

  def periodo_expirado
    
  end


protected
def dispatch
    if @usuario=current_user
        if @usuario.has_role?(:admin)
          redirect_to :controller => "admin"
        elsif @usuario.has_role?(:enlaceevaluador)
          redirect_to :controller => "admin"
        elsif @usuario.has_role?(:revisor)
          redirect_to :controller => "instituciones"
        else
          #redirect_to :action => "index"
          puts "..."
        end
   end
end

end
