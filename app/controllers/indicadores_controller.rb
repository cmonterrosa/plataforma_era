class IndicadoresController < ApplicationController
  require_role [:coordinador, :consejero, :equipotecnico, :adminplat]

   ##################################################
  #    INDICADORES
  #
  ##################################################

  def index
    indicadores_generales
    indicadores_eje1
    indicadores_eje2
    indicadores_eje3
    indicadores_eje4
    indicadores_eje5
  end

  def update_indicadores
    indicadores_generales
    indicadores_eje1
    indicadores_eje2
    indicadores_eje3
    indicadores_eje4
    indicadores_eje5
    render :partial => "detalle", :layout => "only_jquery"
  end

  ## Consulta de indicadores ###

private

  def indicadores_generales
    ### Todas las que poseen cuentas de usuario ##
    #@escuelas = Escuela.find(:all, :select => "e.id", :joins => "e, users u", :conditions => ["e.id = u.escuela_id"])
    ### Solo las registradas ##3
    @escuelas = Escuela.find(:all, :select => "id", :conditions => ["registro_completo = 1"])
    @turnos = Escuela.find(:all, :select => "count(turno)", :conditions => ["turno IS NOT NULL"], :group => "turno")

    ELECT species, COUNT(*) FROM pet GROUP BY species;


    @escuelas_matutinas = Escuela.count(:id, :conditions => ["turno = ? AND id in (?)", "MATUTINO", @escuelas.map{|i|i.id}])
    @escuelas_vespertinas = Escuela.count(:id, :conditions => ["turno = ? AND id in (?)", "VESPERTINO", @escuelas.map{|i|i.id}])

    @alumnos = Escuela.sum(:alu_hom, :conditions => ["alu_hom IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @alumnas = Escuela.sum(:alu_muj, :conditions => ["alu_muj IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @docentes = Escuela.sum(:total_personal_docente, :conditions => ["total_personal_docente IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_admvo = Escuela.sum(:total_personal_admvo, :conditions => ["total_personal_admvo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
    @personal_apoyo = Escuela.sum(:total_personal_apoyo, :conditions => ["total_personal_apoyo IS NOT NULL AND id in (?)", @escuelas.map{|i|i.id}])
  end

  def indicadores_eje1
    @docentes_capacitados_salud = Competencia.sum(:dctes_cap_salud, :conditions => ["dctes_cap_salud IS NOT NULL"])
    @docentes_capacitados_medio_ambiente = Competencia.sum(:dctes_cap_ma, :conditions => [" dctes_cap_ma IS NOT NULL"])
    @alumnos_capacitados_salud = Competencia.sum(:alumn_cap_salud, :conditions => ["alumn_cap_salud IS NOT NULL"])
    @alumnos_capacitados_medio_ambiente = Competencia.sum(:alumn_cap_ma, :conditions => ["alumn_cap_ma IS NOT NULL"])
  end

  def indicadores_eje2
    @total_terreno = Entorno.sum(:superficie_terreno_escuela, :conditions => ["superficie_terreno_escuela IS NOT NULL"])
    @total_areas_verdes = Entorno.sum(:superficie_terreno_escuela_av, :conditions => ["superficie_terreno_escuela_av IS NOT NULL"])
    @porcentaje_total_areas_verdes = (@total_terreno > 0 )? ((@total_areas_verdes.to_f/@total_terreno.to_f) * 100.0).round(3) : 0
    @escuelas_realizan_reforestacion = Entorno.count(:id, :conditions => ["escuela_reforesta = ?", 'SI'])
  end

  def indicadores_eje3
    @total_focos = Huella.sum(:total_focos, :conditions => ["total_focos IS NOT NULL"])
    @focos_ahorradores = Huella.sum(:focos_ahorradores, :conditions => ["focos_ahorradores IS NOT NULL"])
    @porcentaje_focos_ahorradores = (@total_focos > 0 )? ((@focos_ahorradores.to_f/@total_focos.to_f) * 100.0).round(3) : 0
    @escuelas_separan_basura = Huella.count(:id, :conditions => ["sep_residuos_org_inorg = ?", 'SI'])
  end

  def indicadores_eje4
    @escuelas_establecimientos_alimentos_bebidas = Consumo.count(:id, :conditions => ["escuela_establecimiento = ?", 'SI'])
  end

  def indicadores_eje5
    
  end

end
