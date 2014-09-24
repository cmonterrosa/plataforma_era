class InstitucionesController < ApplicationController
require_role [:revisor]

def index
  @evaluadas = []
  @no_evaluadas = []
  #@escuelas_asignadas = Escuela.find(:all, :conditions => ["evaluador_id = ?", current_user.id])
  @escuelas_asignadas = current_user.escuelas
  unless @escuelas_asignadas.empty?
    @escuelas_asignadas.each do |escuela|
      @evaluadas_p = Evaluacion.find(:all, :conditions => ["user_id = ? AND proyecto_id = ?", current_user.id, escuela.diagnostico.proyecto.id], :group => "user_id")
      @evaluadas_d = Evaluacion.find(:all, :conditions => ["user_id = ? AND diagnostico_id = ?", current_user.id, escuela.diagnostico.id])
      if !@evaluadas_p.empty? and !@evaluadas_d.empty?
        @evaluadas << escuela
      else
        @no_evaluadas << escuela
      end
    end
  end
  @evaluadas = @evaluadas.paginate(:page => params[:page], :per_page => 10)
  @no_evaluadas = @no_evaluadas.paginate(:page => params[:page], :per_page => 10)
end

end
