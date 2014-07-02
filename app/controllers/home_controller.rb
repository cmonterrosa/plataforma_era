class HomeController < ApplicationController
  
  
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

end
