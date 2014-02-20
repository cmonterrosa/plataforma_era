# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  #---- Incluimos las utilerias
  include Functions

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout 'era2014'#, :except => :sessions

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

   def clean_string(string)
      (string) ? (return string.to_s.gsub(/\$/, '\$').gsub(/\"/, '\"')) : (return "")
   end

def fecha_string(date=Time.now)
    meses = %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
    dia,mes,anio = date.strftime("%d"), date.strftime("%m"), date.strftime("%Y")
    mes = meses[(mes.to_i - 1)]
    return "#{dia} de #{mes} de #{anio}".upcase
 end

  def verifica_evidencias(diagnostico_id=nil,eje_id=nil)
    ejes=YAML.load_file("#{RAILS_ROOT}/config/ejes.yml")
    eje = ejes["eje#{eje_id}"]
    h= Hash.new
    h["valido"] = true
    h["sin_validar"] = Array.new
    eje.each do |pregunta|
      num_pregunta = pregunta.first
      num_evidencias = Adjunto.count(:id, :conditions => ["diagnostico_id = ? AND eje_id = ? AND numero_pregunta = ?", diagnostico_id, eje_id, num_pregunta])
      #### Si la pregunta necesita evidencia ###
      if pregunta.last == true
        if num_evidencias < 1
          h["valido"] = false
          h["sin_validar"] << num_pregunta
        end
      end
      h["sin_validar"].sort! unless h["sin_validar"].empty?
      #### {:valido => true, :sin_validar = []}
      #### {:valido => false, :sin_validar = [1,2,3,4,5]}
     end
    return h
  end

end
