include SendDocHelper
class ConstanciaController < ApplicationController

  def generar
       @escuela = Escuela.find(params[:id])
      if @escuela
         param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
         #-- Parametros
         param["P_ESCUELA"]={:tipo=>"String", :valor=>clean_string(@escuela.nombre)}
         param["P_UBICACION"]={:tipo=>"String", :valor=>@escuela.municipio}
         param["P_CT"]={:tipo=>"String", :valor=>@escuela.clave}
        if File.exists?(REPORTS_DIR + "/constancia.jasper")
           send_doc_jdbc("constancia", "constancia", param, output_type = 'pdf')
        else
           render :text => "Error"
        end
    else
        render :text => "Imposible generar reporte involucrado, verifique los parámetros"
    end

  end
end
