class InstitucionesController < ApplicationController
#require_role [:revisor]

def index
   @condition= (params[:token]) ? params[:token] : "sin-evaluar"
   repetidas = Array.new
      @diagnosticos_evaluados = Evaluacion.find(:all, :select => "diagnostico_id", :conditions => ["proyecto_id IS NULL AND user_id = ?", current_user.id], :group => "diagnostico_id")
      @proyectos_evaluados = Evaluacion.find(:all, :select => "proyecto_id", :conditions => ["diagnostico_id IS NULL AND user_id = ?", current_user.id], :group => "proyecto_id")
      @escuelas_diagnosticos_evaluados = Escuela.find(:all, :select => "escuelas.*", :joins => "escuelas, diagnosticos d", :conditions => ["escuelas.id = d.escuela_id AND d.id in (?)", @diagnosticos_evaluados.map { |i|i.diagnostico_id  }])
      @escuelas_diagnosticos_proyectos = Escuela.find(:all, :select => "escuelas.*", :joins => "escuelas, diagnosticos d, proyectos p", :conditions => ["escuelas.id = d.escuela_id AND d.id = p.diagnostico_id AND p.id in (?)", @proyectos_evaluados.map { |i|i.proyecto_id  }])
      @escuelas_diagnosticos_evaluados.each{|e| repetidas << @escuelas_diagnosticos_proyectos === e }
      
   if @condition =="evaluadas"
      @escuelas = Escuela.find(:all, :conditions => ["evaluador_id = ? AND id in (?)", current_user.id, repetidas[0].map{|i|i.id}])
   else
     @escuelas = Escuela.find(:all, :conditions => ["evaluador_id = ? AND id not in (?)", current_user.id, repetidas[0].map{|i|i.id}])
   end
   @escuelas = @escuelas.paginate(:page => params[:page], :per_page => 25) if @escuelas
end

end
