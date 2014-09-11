class HomeController < ApplicationController
  
  before_filter :es_revisor?

  
  def index
    
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
def es_revisor?
     if @usuario=current_user
        if @usuario.has_role?(:revisor)
                redirect_to :controller => "instituciones"
        else
              if @usuario.has_role?(:admin) || @usuario.has_role?(:enlaceevaluador)
                  redirect_to :controller => "admin"
              end
        end

      end
end


end
