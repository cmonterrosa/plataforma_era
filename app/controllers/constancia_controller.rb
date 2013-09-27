include SendDocHelper
class ConstanciaController < ApplicationController
  before_filter :login_required
  
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

  def carta_compromiso_basica
    @escuela = Escuela.find(params[:id])
    if @escuela
      param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
      #-- Parametros
      param["P_ESCUELA"]={:tipo=>"String", :valor=>clean_string(@escuela.nombre)}
      param["P_FECHA"]={:tipo=>"String", :valor=>DateTime.now.strftime("%d de %B de %Y").upcase}
      param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>@escuela.municipio}
      param["P_DIRECTOR"]= (@escuela.nombre_director) ? {:tipo=>"String", :valor=>@escuela.nombre_director} : {:tipo=>"String", :valor=>" "}
      param["P_CLAVE"]={:tipo=>"String", :valor=>@escuela.clave}
      param["P_LOCALIDAD"]={:tipo=>"String", :valor=>@escuela.localidad}
      param["P_MUNICIPIO"]={:tipo=>"String", :valor=>@escuela.municipio}
      if File.exists?(REPORTS_DIR + "/carta_compromiso.jasper")
        send_doc_jdbc("carta_compromiso", "carta_compromiso", param, output_type = 'pdf')
      else
        render :text => "Error"
      end
    else
      render :text => "Imposible generar reporte involucrado, verifique los parámetros"
    end
  end
  
end
