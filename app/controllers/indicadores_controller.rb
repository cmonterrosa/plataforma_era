class IndicadoresController < ApplicationController
  require_role [:coordinador, :consejero, :equipotecnico, :adminplat]

  ##################################################
  #                                                                                                                        #
  #                                   INDICADORES                                                                #
  #                                                                                                                        #
  ##################################################

  def index
    set_ciclo
  end

  def update_indicadores
    set_ciclo
    render :partial => "detalle", :layout => "only_jquery"
  end

  ## Consulta de indicadores ###

private

  def indicadores_generales
    ### Todas las que poseen cuentas de usuario ##
    @escuelas = Escuela.find(:all, :select => "e.id", :joins => "e, users u", :conditions => ["e.id = u.escuela_id"])
    ### Solo las registradas ##3
    #@escuelas = Escuela.find(:all, :select => "id", :conditions => ["registro_completo = 1"])
    @turnos = Escuela.find(:all, :select => "turno, count(id) as numero", :conditions => ["id in (?)", @escuelas.map{|i|i.id}], :group => "turno")
    @alumnos = Escuela.sum(:alu_hom, :conditions => ["alu_hom IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @alumnas = Escuela.sum(:alu_muj, :conditions => ["alu_muj IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @docentes = Escuela.sum(:total_personal_docente, :conditions => ["total_personal_docente IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_admvo = Escuela.sum(:total_personal_admvo, :conditions => ["total_personal_admvo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_apoyo = Escuela.sum(:total_personal_apoyo, :conditions => ["total_personal_apoyo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
  end

  #### INDICADORES CICLO ACTUAL #####

  def indicadores_ciclo2015eje1
    @docentes_capacitados_salud = Competencia.sum(:dctes_cap_salud, :conditions => ["dctes_cap_salud IS NOT NULL"])
    @docentes_capacitados_medio_ambiente = Competencia.sum(:dctes_cap_ma, :conditions => [" dctes_cap_ma IS NOT NULL"])
    @alumnos_capacitados_salud = Competencia.sum(:alumn_cap_salud, :conditions => ["alumn_cap_salud IS NOT NULL"])
    @alumnos_capacitados_medio_ambiente = Competencia.sum(:alumn_cap_ma, :conditions => ["alumn_cap_ma IS NOT NULL"])
    @docentes_aplican_conocimientos = Competencia.sum(:dctes_aplican_conocimto, :conditions => ["dctes_aplican_conocimto IS NOT NULL"])
  end

  def indicadores_ciclo2015eje2
    @total_terreno = Entorno.sum(:superficie_terreno_escuela, :conditions => ["superficie_terreno_escuela IS NOT NULL"])
    @total_areas_verdes = Entorno.sum(:superficie_terreno_escuela_av, :conditions => ["superficie_terreno_escuela_av IS NOT NULL"])
    @porcentaje_total_areas_verdes = (@total_terreno > 0 )? ((@total_areas_verdes.to_f/@total_terreno.to_f) * 100.0).round(3) : 0
    @escuelas_realizan_reforestacion = Entorno.count(:id, :conditions => ["escuela_reforesta = ?", 'SI'])
    @espacios = EscuelasEspacio.find(:all, :select => "sum(escesp.numero) as numero, e.descripcion",
                                                       :joins => "escesp, espacios e, entornos en",
                                                       :conditions => "en.id=escesp.entorno_id AND escesp.espacio_id=e.id",
                                                       :group => "escesp.espacio_id")
  end

  def indicadores_ciclo2015eje3
    @total_focos = Huella.sum(:total_focos, :conditions => ["total_focos IS NOT NULL"])
    @focos_ahorradores = Huella.sum(:focos_ahorradores, :conditions => ["focos_ahorradores IS NOT NULL"])
    @porcentaje_focos_ahorradores = (@total_focos > 0 )? ((@focos_ahorradores.to_f/@total_focos.to_f) * 100.0).round(3) : 0
    @escuelas_abastecimiento_agua = ServicioAgua.find(:all, :select => "count(hsa.servicio_agua_id) as numero, sa.descripcion",
                                                            :joins => "sa, huellas_servicio_aguas hsa, huellas h",
                                                            :conditions => "sa.id=hsa.servicio_agua_id AND hsa.huella_id=h.id",
                                                            :group => "sa.descripcion")
    @escuelas_separan_basura = Huella.count(:id, :conditions => ["sep_residuos_org_inorg = ?", 'SI'])




  end

  def indicadores_ciclo2015eje4
    @escuelas_establecimientos_alimentos_bebidas = Consumo.count(:id, :conditions => ["escuela_establecimiento = ?", 'SI'])
  end

  def indicadores_ciclo2015eje5
    
  end

  #### INDICADORES CICLO 2013-2014 ####

  def indicadores_ciclo2014eje1
    @docentes_capacitados_salud = Competencia.sum(:dctes_cap_salud, :conditions => ["dctes_cap_salud IS NOT NULL"])
    @docentes_capacitados_medio_ambiente = Competencia.sum(:dctes_cap_ma, :conditions => [" dctes_cap_ma IS NOT NULL"])
    @alumnos_capacitados_salud = Competencia.sum(:alumn_cap_salud, :conditions => ["alumn_cap_salud IS NOT NULL"])
    @alumnos_capacitados_medio_ambiente = Competencia.sum(:alumn_cap_ma, :conditions => ["alumn_cap_ma IS NOT NULL"])
    @docentes_aplican_conocimientos = Competencia.sum(:dctes_aplican_conocimto, :conditions => ["dctes_aplican_conocimto IS NOT NULL"])
  end

  def indicadores_ciclo2014eje2
    @total_terreno = Entorno.sum(:superficie_terreno_escuela, :conditions => ["superficie_terreno_escuela IS NOT NULL"])
    @total_areas_verdes = Entorno.sum(:superficie_terreno_escuela_av, :conditions => ["superficie_terreno_escuela_av IS NOT NULL"])
    @porcentaje_total_areas_verdes = (@total_terreno > 0 )? ((@total_areas_verdes.to_f/@total_terreno.to_f) * 100.0).round(3) : 0
#    @escuelas_realizan_reforestacion = Entorno.count(:id, :conditions => ["escuela_reforesta = ?", 'SI'])
    @espacios = EscuelasEspacio.find(:all, :select => "sum(escesp.numero) as numero, e.descripcion",
                                                       :joins => "escesp, espacios e, entornos en",
                                                       :conditions => "en.id=escesp.entorno_id AND escesp.espacio_id=e.id",
                                                       :group => "escesp.espacio_id")
  end

  def indicadores_ciclo2014eje3
    @total_focos = Huella.sum(:total_focos, :conditions => ["total_focos IS NOT NULL"])
    @focos_ahorradores = Huella.sum(:focos_ahorradores, :conditions => ["focos_ahorradores IS NOT NULL"])
    @porcentaje_focos_ahorradores = (@total_focos > 0 )? ((@focos_ahorradores.to_f/@total_focos.to_f) * 100.0).round(3) : 0
    #@escuelas_abastecimiento_agua = ServicioAgua.find(:all, :select => "count(hsa.servicio_agua_id) as numero, sa.descripcion",
    #                                                        :joins => "sa, huellas_servicio_aguas hsa, huellas h",
    #                                                        :conditions => "sa.id=hsa.servicio_agua_id AND hsa.huella_id=h.id",
     #                                                       :group => "sa.descripcion")
    @escuelas_separan_basura = Huella.count(:id, :conditions => ["sep_residuos_org_inorg = ?", 'SI'])




  end

  def indicadores_ciclo2014eje4
    @escuelas_establecimientos_alimentos_bebidas = Consumo.count(:id, :conditions => ["escuela_establecimiento = ?", 'SI'])
  end

  def indicadores_ciclo2014eje5
    
  end



  def set_database(environment)
     Escuela.establish_connection(environment)
     Competencia.establish_connection(environment)
     Entorno.establish_connection(environment)
     Huella.establish_connection(environment)
     Consumo.establish_connection(environment)
     Espacio.establish_connection(environment)
     ServicioAgua.establish_connection(environment)
  end


  def set_ciclo
    @ciclo = (params[:ciclo])? "#{params[:ciclo]}" : "#{CICLO_ESCOLAR}"
    
    case @ciclo
      when "2013-2014"
        set_database("era2014")
        indicadores_generales
        render :partial => "generales", :layout => "era2014"

    when "2014-2015"
        set_database(RAILS_ENV)
        indicadores_generales
        indicadores_ciclo2015eje1
        indicadores_ciclo2015eje2
        indicadores_ciclo2015eje3
        indicadores_ciclo2015eje4
        indicadores_ciclo2015eje5
    end
  end

end
