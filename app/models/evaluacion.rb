include Functions
class Evaluacion < ActiveRecord::Base

###--- DESARROLLO DE COMPETENCIAS
def puntaje_eje1_p1
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if @competencia.docentes_capacitados_sma.to_i > 0
    @eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje1.id, 1], :order => "eje_id")
    @eje1.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje1_p1 = (((@competencia.docentes_capacitados_sma.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p1.to_f).round(3)
  end

  return valido ? @eje1_p1 : 0
end

def puntaje_eje1_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if @competencia.docentes_aplican_conocimientos.to_i > 0
    @eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje1.id, 2], :order => "eje_id")
    @eje1.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje1_p2 = (((@competencia.docentes_aplican_conocimientos.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p2.to_f).round(3)
  end

  return valido ? @eje1_p2 : 0
end

def puntaje_eje1_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if @competencia.docentes_involucran_actividades.to_i > 0
    @eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje1.id, 3], :order => "eje_id")
    @eje1.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje1_p3 = (((@competencia.docentes_involucran_actividades.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p3.to_f).round(3)
  end

  return valido ? @eje1_p3 : 0
end

def puntaje_eje1_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if @competencia.alumnos_capacitados_docentes.to_i > 0
    @eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje1.id, 4], :order => "eje_id")
    @eje1.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje1_p4 = (((@competencia.alumnos_capacitados_docentes.to_i / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p4.to_f).round(3)
  end

  return valido ? @eje1_p4 : 0
end

def puntaje_eje1_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if @competencia.alumnos_capacitados_instituciones.to_i > 0
    @eje1 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje1.id, 5], :order => "eje_id")
    @eje1.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje1_p5 = (((@competencia.alumnos_capacitados_instituciones.to_i / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p5.to_f).round(3)
  end

  return valido ? @eje1_p5 : 0
end

###--- ENTORNO SALUDABLE
def puntaje_eje2_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @entorno = @diagnostico.entorno if @diagnostico.entorno

  if @entorno.superficie_terreno_escuela.to_f > 0 and  @entorno.superficie_terreno_escuela_av.to_f <= @entorno.superficie_terreno_escuela.to_f
    @eje2_p2 = ((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round > 25 ? ptos_superficie(25) : ptos_superficie(((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round)
  else
    @eje2_p2 = 0
  end
    
  return @eje2_p2
end

def puntaje_eje2_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @entorno = @diagnostico.entorno if @diagnostico.entorno
  @s_acciones = multiple_selected(@entorno.acciones) if @entorno.acciones
  eje2 = CatalogoEje.find_by_clave("EJE2")
  unless @s_acciones.include?("NING")
    @eje2 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje2.id, 6], :order => "eje_id")
    @eje2.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    if @diagnostico.escuela.nivel_descripcion == "BACHILLERATO"
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
      @eje2_p6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
    else
      @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
      @eje2_p6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
    end
  end
  
  return valido ? @eje2_p6 : 0
end

##-- HUELLA ECOLOGICA
def puntaje_eje3_p1
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  eje3 = CatalogoEje.find_by_clave("EJE3")
  if @huella.capacitacion_ahorro_energia.to_f > 0
    @eje3 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje3.id, 1], :order => "eje_id")
    @eje3.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje3_p1 = (((@huella.capacitacion_ahorro_energia.to_f / 2 ) * 100) * $huella_p1.to_f).round(3)
  end

  return valido ? @eje3_p1 : 0
end

def puntaje_eje3_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  eje3 = CatalogoEje.find_by_clave("EJE3")
  unless @huella.energia_electrica and @huella.energia_electrica.clave == "SUOP"
    @eje3 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje3.id, 2], :order => "eje_id")
    @eje3.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    if @huella.consumo_anterior.to_f > @huella.consumo_actual.to_f and valido
      @eje3_p2 = $huella_p2 * 100
    else
      @eje3_p2 = 0
    end
  
  end

  return @eje3_p2
end

def puntaje_eje3_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella

  if @huella.focos_ahorradores.to_f > 0
    @eje3_p3 = (((@huella.focos_ahorradores.to_f / @huella.total_focos.to_f ) * 100) * $huella_p3.to_f).round(3)
  else
    @eje3_p3 = 0
  end
  
  return @eje3_p3
end

def puntaje_eje3_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella

  if @huella.red_publica_agua == "SI"
    @eje3_p4 = $huella_p4 * 100
  else
    @eje3_p4 = 0
  end

  return @eje3_p4
end

def puntaje_eje3_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @eje3_p5 = (((@huella.mantto_inst.to_f / 2 ) * 100) * $huella_p5.to_f).round(3)
  
  return @eje3_p5
end

def puntaje_eje3_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella

  if @huella.recip_residuos_solid == "SI"
    @eje3_p6 = $huella_p6 * 100
  else
    @eje3_p6 = 0
  end
  
  return @eje3_p6
end

def puntaje_eje3_p7
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella

  if @huella.sep_residuos_org_inorg == "SI"
    @eje3_p7 = $huella_p7 * 100
  else
    @eje3_p7 = 0
  end

  return @eje3_p7
end

def puntaje_eje3_p8
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella

  if @huella.elabora_compostas == "SI"
    @eje3_p8 = $huella_p8 * 100
  else
    @eje3_p8 = 0
  end

  return @eje3_p8
end

def puntaje_eje3_p9
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  
  @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos
  if @s_inorganicos.size == 1 and @huella.inorganicos[0]['clave'] == "NING"
    @eje3_p9 = 0
  else
    @eje3_p9 = ptos_inorganicos(@s_inorganicos.size)
  end

  return @eje3_p9
end

##-- CONSUMO RESPONSABLE / SALUDABLE
def puntaje_eje4_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo

  if @consumo.conocen_lineamientos_grales == "SI"
    @eje4_p2 = $consumo_p2 * 100
  else
    @eje4_p2 = 0
  end

  return @eje4_p2
end

def puntaje_eje4_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  eje4 = CatalogoEje.find_by_clave("EJE4")
  if @consumo.capacitacion_alim_bebidas == "SI"
    @eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje4.id, 3], :order => "eje_id")
    @eje4.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje4_p3 = $consumo_p3 * 100
  end

  return valido ? @eje4_p3 : 0
end

def puntaje_eje4_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  
  @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
  @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
  @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
  @t_preparacions = Preparacion.all
  @t_utensilios = Utensilio.all
  @t_higiene = Higiene.all

  @preparacions = @s_preparacions.size > 0 ? (((@s_preparacions.size.to_f / @t_preparacions.size.to_f) * 100) * $consumo_p4) : 0
  @utensilios = @s_utensilios.size > 0 ? (((@s_utensilios.size.to_f / @t_utensilios.size.to_f) * 100) * $consumo_p4) : 0
  @higienes = @s_higienes.size > 0 ? (((@s_higienes.size.to_f / @t_higiene.size.to_f) * 100) * $consumo_p4) : 0

  if (@s_preparacions.size + @s_utensilios.size + @s_higienes.size).to_f > 0
    @eje4_p4 = (@preparacions + @utensilios + @higienes).round(3)
  else
    @eje4_p4 = 0
  end

  return @eje4_p4
end

def puntaje_eje4_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  
  @s_bebidas = multiple_selected(@consumo.bebidas) if @consumo.bebidas
  @s_alimentos = multiple_selected(@consumo.alimentos) if @consumo.alimentos
  @s_botanas = multiple_selected(@consumo.botanas) if @consumo.botanas
  @s_reposterias = multiple_selected(@consumo.reposterias) if @consumo.reposterias

  @b_saludables = Bebida.find_all_by_tipo("SALUDABLE")
  @select_bebidas = 0
  @s_bebidas.each do |bebida|
    @select_bebidas+=1 if @b_saludables.any? { |b| b[:clave] == bebida }
  end
  @bebidas = @select_bebidas.to_f > 0 ? (((@select_bebidas.to_f / @s_bebidas.size.to_f)* 100)* $consumo_p5).round(3) : 0

  @a_saludables = Alimento.find_all_by_tipo("SALUDABLE")
  @select_alimentos = 0
  @s_alimentos.each do |alimento|
    @select_alimentos+=1 if @a_saludables.any? { |b| b[:clave] == alimento }
  end
  @alimentos = @select_alimentos.to_f > 0 ? (((@select_alimentos.to_f / @s_alimentos.size.to_f)* 100)* $consumo_p5).round(3) : 0

  @bo_saludables = Botana.find_all_by_tipo("SALUDABLE")
  @select_botanas = 0
  @s_botanas.each do |botana|
    @select_botanas+=1 if @bo_saludables.any? { |b| b[:clave] == botana }
  end
  @botanas = @select_botanas.to_f > 0 ? (((@select_botanas.to_f / @s_botanas.size.to_f)* 100)* $consumo_p5).round(3) : 0

  @r_saludables = Reposteria.find_all_by_tipo("SALUDABLE")
  @select_reposterias = 0
  @s_reposterias.each do |reposteria|
    @select_reposterias+=1 if @r_saludables.any? { |b| b[:clave] == reposteria }
  end
  @reposterias =  @select_reposterias.to_f > 0 ? (((@select_reposterias.to_f / @s_reposterias.size.to_f)* 100)* $consumo_p5).round(3) : 0

  if (@bebidas + @alimentos + @botanas + @reposterias).to_f > 0
    @eje4_p5 = @bebidas + @alimentos + @botanas + @reposterias
  else
    @eje4_p5 = 0
  end

  return @eje4_p5
end

def puntaje_eje4_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  
  @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
  @m_recomendables = Material.find_all_by_tipo("RECOMENDABLES")
  @select_materials = 0
  @s_materials.each do |material|
    @select_materials+=1 if @m_recomendables.any? { |b| b[:clave] == material }
  end
  @eje4_p6 = (((@select_materials.to_f / @s_materials.size.to_f)* 100)* $consumo_p6).round(3)

  return @eje4_p6
end

def puntaje_eje4_p7
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  
  @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica
  @eje4_p7 = ptos_afisica(@s_afisicas)

  return @eje4_p7
end

def puntaje_eje4_p8
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  
  minutos_activacion_fisica = (@consumo.minutos_activacion_fisica) ? @consumo.minutos_activacion_fisica : 0
  if minutos_activacion_fisica > 30
    @eje4_p7 = ptos_minutos(30)
  else
    @eje4_p7 = ptos_minutos(@consumo.minutos_activacion_fisica)
  end

  return @eje4_p7
end

##-- PARTICIPACION COMUNITARIA
def puntaje_eje5_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @participacion = @diagnostico.participacion if @diagnostico.participacion
  eje5 = CatalogoEje.find_by_clave("EJE5")
  if @participacion.num_padres_familia.to_i > 0
    @eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje5.id, 2], :order => "eje_id")
    @eje5.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje5_p2 = (((@participacion.capacitacion_salud_ma.to_f / @participacion.num_padres_familia.to_f ) * 100) * $participacion_p2.to_f).round(3)
  end

  return valido ? @eje5_p2 : 0
end

def puntaje_eje5_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @participacion = @diagnostico.participacion if @diagnostico.participacion
  eje5 = CatalogoEje.find_by_clave("EJE5")
  if @participacion.proy_escolares_ma.to_i > 0
    @eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje5.id, 3], :order => "eje_id")
    @eje5.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje5_p3 = ptos_participacion(@participacion.proy_escolares_ma)
  end

  return valido ? @eje5_p3 : 0
end

def puntaje_eje5_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @participacion = @diagnostico.participacion if @diagnostico.participacion
  eje5 = CatalogoEje.find_by_clave("EJE5")
  if @participacion.proy_escolares_salud.to_i > 0
    @eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje5.id, 4], :order => "eje_id")
    @eje5.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje5_p4 = ptos_participacion(@participacion.proy_escolares_salud)
  end

  return valido ? @eje5_p4 : 0
end

def puntaje_eje5_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @participacion = @diagnostico.participacion if @diagnostico.participacion
  eje5 = CatalogoEje.find_by_clave("EJE5")
  if @participacion.act_salud_ma.to_i > 0
    @eje5 = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje5.id, 5], :order => "eje_id")
    @eje5.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje5_p5 = ptos_participacion(@participacion.act_salud_ma)
  end

  return valido ? @eje5_p5 : 0
end



def puntaje_total_eje1
  return (($competencia_p1.to_f + $competencia_p2.to_f + $competencia_p3.to_f + $competencia_p5.to_f + $competencia_p5.to_f)*100).round(3)
end

def puntaje_total_eje2
  return (($entorno_p2.to_f + $entorno_p6.to_f)*100).round(3)
end

def puntaje_total_eje3
  return (($huella_p1.to_f + $huella_p2.to_f + $huella_p3.to_f + $huella_p4.to_f + $huella_p5.to_f + $huella_p6.to_f + $huella_p7.to_f + $huella_p8.to_f + $huella_p9.to_f)*100).round(3)
end

def puntaje_total_eje4
  return (($consumo_p2.to_f + $consumo_p3.to_f + ($consumo_p4.to_f * 3) + ($consumo_p5.to_f * 4) + $consumo_p6.to_f + $consumo_p7.to_f + $consumo_p8.to_f)*100 ).round(3)
end

def puntaje_total_eje5
  return (($participacion_p2.to_f + $participacion_p3.to_f + $participacion_p4.to_f + $participacion_p5.to_f)*100).round(3)
end

def puntaje_total_obtenido_eje1
  return (puntaje_eje1_p1 + puntaje_eje1_p2 + puntaje_eje1_p3 + puntaje_eje1_p4 + puntaje_eje1_p5).round(3)
end

def puntaje_total_obtenido_eje2
  return (puntaje_eje2_p2 + puntaje_eje2_p6).round(3)
end

def puntaje_total_obtenido_eje3
  return (puntaje_eje3_p1 + puntaje_eje3_p2 + puntaje_eje3_p3 + puntaje_eje3_p4 + puntaje_eje3_p5 + puntaje_eje3_p6 + puntaje_eje3_p7 + puntaje_eje3_p8 + puntaje_eje3_p9).round(3)
end

def puntaje_total_obtenido_eje4
  return (puntaje_eje4_p2 + puntaje_eje4_p3 + puntaje_eje4_p4 + puntaje_eje4_p5 + puntaje_eje4_p6 + puntaje_eje4_p7 + puntaje_eje4_p8).round(3)
end

def puntaje_total_obtenido_eje5
  return (puntaje_eje5_p2 + puntaje_eje5_p3 + puntaje_eje5_p4 + puntaje_eje5_p5).round(3)
end

def puntaje_total_novidencias
#### Aqui hacemos una consulta para obtener el ppuntaje de las no evidencias
end

end
