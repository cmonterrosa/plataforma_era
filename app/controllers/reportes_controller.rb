class ReportesController < ApplicationController

 #require_role 'escuela'

  def index
   #### Buscamos reportes de cada escuela #####
   miescuela = Escuela.find_by_clave(current_user.login)
   @reportes = Reporte.find(:all, :conditions => ["escuela_id = ?", miescuela.id])
  end

  def reportes
  end

end
