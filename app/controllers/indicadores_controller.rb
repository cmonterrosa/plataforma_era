class IndicadoresController < ApplicationController
  require_role [:coordinador, :consejero, :equipotecnico, :adminplat]

  #########################################################
  #                                                                                                                                         #                                                #
  #                                   INDICADORES                                                                                 #
  #                                                                                                                                         #
  #########################################################

  def index
    @token = params[:token] if params[:token]
    @tipo = (@token=='p')? "proyecto" : "diagnostico"
    set_ciclo(@tipo + "_id")
  end

  def update_indicadores
    @token = params[:token] if params[:token]
    @tipo = (@token=='p')? "proyecto" : "diagnostico"
    set_ciclo(@tipo + "_id")
    render :partial => "detalle", :layout => "only_jquery"
  end

  ## Consulta de indicadores ###

private

  def indicadores_generales
    @sostenimientos = Escuela.find(:all, :select => "sostenimiento, count(id) as numero", :conditions => ["sostenimiento IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}], :group => "sostenimiento having numero > 0")
    @turnos = Escuela.find(:all, :select => "turno, count(id) as numero", :conditions => ["turno IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}], :group => "turno having numero > 0")
    @alumnos = Escuela.sum(:alu_hom, :conditions => ["alu_hom IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @alumnas = Escuela.sum(:alu_muj, :conditions => ["alu_muj IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @docentes = Escuela.sum(:total_personal_docente, :conditions => ["total_personal_docente IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @docentes_apoyo = Escuela.sum(:total_personal_docente_apoyo, :conditions => ["total_personal_docente_apoyo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_admvo = Escuela.sum(:total_personal_admvo, :conditions => ["total_personal_admvo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_apoyo = Escuela.sum(:total_personal_apoyo, :conditions => ["total_personal_apoyo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
  end

  #### INDICADORES CICLO ACTUAL #####

  def indicadores_ciclo2015eje1(tipo)
    @docentes_capacitados_salud = Competencia.sum(:dctes_cap_salud, :conditions => ["#{tipo} IS NOT NULL AND dctes_cap_salud IS NOT NULL"])
    @docentes_capacitados_medio_ambiente = Competencia.sum(:dctes_cap_ma, :conditions => ["#{tipo} IS NOT NULL AND dctes_cap_ma IS NOT NULL"])
    @alumnos_capacitados_salud = Competencia.sum(:alumn_cap_salud, :conditions => ["#{tipo} IS NOT NULL AND alumn_cap_salud IS NOT NULL"])
    @alumnos_capacitados_medio_ambiente = Competencia.sum(:alumn_cap_ma, :conditions => ["#{tipo} IS NOT NULL AND alumn_cap_ma IS NOT NULL"])
    @alumnos_capacitados_docentes = Competencia.sum(:alumn_cap_dctes, :conditions => ["#{tipo} IS NOT NULL AND alumn_cap_dctes IS NOT NULL"])
    @docentes_aplican_conocimientos = Competencia.sum(:dctes_aplican_conocimto, :conditions => ["#{tipo} IS NOT NULL AND dctes_aplican_conocimto IS NOT NULL"])
    @dependencias_capacitadoras = DocentesCapacitado.find(:all, :select => "sum(dc.numero) as numero, cap.descripcion",
                                                       :joins => "dc, dcapacitadoras cap, competencias comp",
                                                       :conditions => "comp.id=dc.competencia_id AND dc.dcapacitadora_id=cap.id AND  comp.#{tipo} IS NOT NULL",
                                                       :group => "dc.dcapacitadora_id")
  end

  def indicadores_ciclo2015eje2(tipo)
    @total_terreno = Entorno.sum(:superficie_terreno_escuela, :conditions => ["#{tipo} IS NOT NULL AND superficie_terreno_escuela IS NOT NULL"])
    @total_areas_verdes = Entorno.sum(:superficie_terreno_escuela_av, :conditions => ["#{tipo} IS NOT NULL AND superficie_terreno_escuela_av IS NOT NULL"])
    #@porcentaje_total_areas_verdes = (@total_terreno > 0 )? ((@total_areas_verdes.to_f/@total_terreno.to_f) * 100.0).round(3) : 0
    @arboles_sembrados = Entorno.sum(:escuela_reforesta_num, :conditions => ["#{tipo} IS NOT NULL AND escuela_reforesta_num IS NOT NULL"])
    @arboles_nativos = Entorno.sum(:arboles_nativos_num, :conditions => ["#{tipo} IS NOT NULL AND arboles_nativos = ? AND arboles_nativos_num IS NOT NULL", 'SI'])
    @arboles_no_nativos = Entorno.sum(:arboles_no_nativos_num, :conditions => ["#{tipo} IS NOT NULL AND arboles_no_nativos = ? AND arboles_no_nativos_num IS NOT NULL", 'SI'])
    @escuelas_realizan_reforestacion = Entorno.count(:id, :conditions => ["#{tipo} IS NOT NULL AND escuela_reforesta = ?", 'SI'])
    @espacios = EscuelasEspacio.find(:all, :select => "sum(escesp.numero) as numero, e.descripcion",
                                                       :joins => "escesp, espacios e, entornos en",
                                                       :conditions => "en.id=escesp.entorno_id AND escesp.espacio_id=e.id AND en.#{tipo} IS NOT NULL",
                                                       :group => "escesp.espacio_id")
  end

  def indicadores_ciclo2015eje3(tipo)
    @capacitacion_ahorro_energia_fide =  Huella.count(:capacitacion_ahorro_energia, :conditions => ["#{tipo} IS NOT NULL AND capacitacion_ahorro_energia IS NOT NULL AND capacitacion_ahorro_energia = ?", 'SI'])
    @consumo_anterior_kw = Huella.sum(:consumo_anterior, :conditions => ["#{tipo} IS NOT NULL AND consumo_anterior IS NOT NULL"])
    @consumo_actual_kw = Huella.sum(:consumo_actual, :conditions => ["#{tipo} IS NOT NULL AND consumo_actual IS NOT NULL"])
    @total_focos = Huella.sum(:total_focos, :conditions => ["#{tipo} IS NOT NULL AND total_focos IS NOT NULL"])
    @focos_ahorradores = Huella.sum(:focos_ahorradores, :conditions => ["#{tipo} IS NOT NULL AND focos_ahorradores IS NOT NULL"])
    @focos_incandescentes = Huella.sum(:focos_incandescentes, :conditions => ["#{tipo} IS NOT NULL AND focos_incandescentes IS NOT NULL"])
    #@porcentaje_focos_ahorradores = (@total_focos > 0 )? ((@focos_ahorradores.to_f/@total_focos.to_f) * 100.0).round(3) : 0
    @escuelas_abastecimiento_agua = ServicioAgua.find(:all, :select => "count(hsa.servicio_agua_id) as numero, sa.descripcion",
                                                            :joins => "sa, huellas_servicio_aguas hsa, huellas h",
                                                            :conditions => "sa.id=hsa.servicio_agua_id AND hsa.huella_id=h.id AND h.#{tipo} IS NOT NULL",
                                                            :group => "sa.descripcion")
    @escuelas_separan_basura = Huella.count(:id, :conditions => ["sep_residuos_org_inorg = ?", 'SI'])
    @escuelas_elaboran_compostas = Huella.count(:elabora_compostas, :conditions => ["#{tipo} IS NOT NULL AND elabora_compostas IS NOT NULL"])
    @escuelas_mantenimiento_instalaciones = Huella.count(:mantto_inst, :conditions => ["#{tipo} IS NOT NULL AND mantto_inst IS NOT NULL AND mantto_inst > 0"])
    @escuelas_tipos_energia_electrica = Huella.find(:all, :select => "count(h.energia_electrica_id) as numero, ee.descripcion",
                                                          :joins => "h, energia_electricas ee",
                                                          :conditions => "h.energia_electrica_id=ee.id AND h.#{tipo} IS NOT NULL",
                                                          :group => "ee.clave")

 end

  def indicadores_ciclo2015eje4(tipo)
    @escuelas_establecimientos_alimentos_bebidas = Consumo.count(:id, :conditions => ["#{tipo} IS NOT NULL AND escuela_establecimiento = ?", 'SI'])
    @escuelas_conocen_lineamientos_generales = Consumo.count(:id, :conditions => ["#{tipo} IS NOT NULL AND capacitacion_alim_bebidas = ?", 'SI'])
    @escuelas_aplican_lineamientos_generales = Consumo.count(:id, :conditions => ["#{tipo} IS NOT NULL AND conocen_lineamientos_grales = ?", 'SI'])
    @escuelas_realizan_activicion_fisica = Consumo.count("c.frecuencia_afisica_id", :joins => "c, frecuencia_afisicas fa", :conditions => ["c.#{tipo} IS NOT NULL AND c.frecuencia_afisica_id=fa.id AND fa.clave NOT IN (?)", 'NOSR'])
  end

  def indicadores_ciclo2015eje5(tipo)
    @padres_familia_capacitados = Participacion.sum(:capacitacion_salud_ma, :conditions => ["#{tipo} IS NOT NULL AND capacitacion_salud_ma IS NOT NULL"])
    @dependencias_capacitadoras_padres = CapacitacionPadre.find(:all, :select => "sum(cp.numero_capacitaciones) as numero, cap.descripcion",
                                                       :joins => "cp, dcapacitadoras cap, participacions part",
                                                       :conditions => "part.id=cp.participacion_id AND cp.dcapacitadora_id=cap.id",
                                                       :group => "cp.dcapacitadora_id")
    @proyectos_medioambiente =  Pescolar.count("pe.participacion_id", :joins => "pe, participacions p", :conditions => ["p.id = pe.participacion_id AND p.#{tipo} IS NOT NULL AND pe.materia= ?",  'MEDIOAMBIENTE'])
    @proyectos_salud =  Pescolar.count("pe.participacion_id", :joins => "pe, participacions p", :conditions => ["p.id = pe.participacion_id AND p.#{tipo} IS NOT NULL AND pe.materia= ?",  'SALUD'])
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


  def set_ciclo(tipo='diagnostico_id')
    @ciclo = (params[:ciclo])? "#{params[:ciclo]}" : "#{CICLO_ESCOLAR}"
    case @ciclo
      when "2013-2014"
        set_database("era2014")
        ### Todas las que poseen cuentas de usuario ##
        @escuelas = Escuela.find(:all, :select => "e.id", :joins => "e, users u", :conditions => ["e.id = u.escuela_id AND e.beneficiada = ?", true])
        indicadores_generales
        render :partial => "generales", :layout => "era2014"

    when "2014-2015"
        set_database(RAILS_ENV)
        ### Todas las que poseen cuentas de usuario ##
        #@escuelas = Escuela.find(:all, :select => "e.id", :joins => "e, users u", :conditions => ["e.id = u.escuela_id AND e.id NOT IN (select escuela_id as id from antecedentes)"])
        @escuelas = Generacion.find(2).escuelas
        ### Solo las registradas ##
        indicadores_generales
        indicadores_ciclo2015eje1(tipo)
        indicadores_ciclo2015eje2(tipo)
        indicadores_ciclo2015eje3(tipo)
        indicadores_ciclo2015eje4(tipo)
        indicadores_ciclo2015eje5(tipo)
    end
  end

end
