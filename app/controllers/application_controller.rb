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

  layout 'era', :except => :sessions

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

end
