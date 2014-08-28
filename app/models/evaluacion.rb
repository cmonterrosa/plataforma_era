class Evaluacion < ActiveRecord::Base

 ########## Metodos donde se obtienen los puntajes #####
def puntaje_eje1_p1
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje1 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 1], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje1 << e if catalogo_eje.clave == "EJE1"
  end
  @eje1.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@competencia.docentes_capacitados_sma.to_i > 0 ? (((@competencia.docentes_capacitados_sma.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p1.to_f).round(3) : 0) : 0
end

def puntaje_eje1_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje1 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 2], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje1 << e if catalogo_eje.clave == "EJE1"
  end
  @eje1.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@competencia.docentes_aplican_conocimientos.to_i > 0 ? (((@competencia.docentes_aplican_conocimientos.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p2.to_f).round(3) : 0): 0
end

def puntaje_eje1_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje1 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 3], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje1 << e if catalogo_eje.clave == "EJE1"
  end
  @eje1.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@competencia.docentes_involucran_actividades.to_i > 0 ? (((@competencia.docentes_involucran_actividades.to_i / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p3.to_f).round(3) : 0): 0
end

def puntaje_eje1_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje1 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 4], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje1 << e if catalogo_eje.clave == "EJE1"
  end
  @eje1.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@competencia.alumnos_capacitados_docentes.to_i > 0 ? (((@competencia.alumnos_capacitados_docentes.to_i / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p4.to_f).round(3) : 0): 0
end

def puntaje_eje1_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje1 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @competencia = @diagnostico.competencia if @diagnostico.competencia
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 5], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje1 << e if catalogo_eje.clave == "EJE1"
  end
  @eje1.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@competencia.alumnos_capacitados_instituciones.to_i > 0 ? (((@competencia.alumnos_capacitados_instituciones.to_i / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p5.to_f).round(3) : 0): 0
end

def puntaje_eje2_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @eje2 = []
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @entorno = @diagnostico.entorno if @diagnostico.entorno
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 2], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje2 << e if catalogo_eje.clave == "EJE2"
  end
  @eje2.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  if @entorno.superficie_terreno_escuela_av.to_f > 0  and @entorno.superficie_terreno_escuela.to_f > 0
    ((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round > 25 ? @ep2 = ptos_superficie(25) : @ep2 = ptos_superficie(((@entorno.superficie_terreno_escuela_av.to_f / @entorno.superficie_terreno_escuela.to_f) * 100).round)
  else
    @ep2 = 0
  end

  return valido ? @ep2 : 0
end

def puntaje_eje2_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @entorno = @diagnostico.entorno if @diagnostico.entorno
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 6], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje2 << e if catalogo_eje.clave == "EJE2"
  end
  @eje2.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  @s_acciones = multiple_selected_id(@entorno.acciones) if @entorno.acciones
  if @diagnostico.escuela.nivel_descripcion == "BACHILLERATO"
  @acciones = Accione.find(:all, :conditions => ["clave not in ('AC01')"])
    @ep6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
  else
    @acciones = Accione.find(:all, :conditions => ["clave not in ('AC00')"])
    @ep6 = (((@s_acciones.size.to_f / 4)* 100) * $entorno_p6.to_f).round(3)
  end

  return valido ? @ep6 : 0
end

def puntaje_eje3_p1
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 1], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@huella.capacitacion_ahorro_energia.to_f > 0 ? (((@huella.capacitacion_ahorro_energia.to_f / 2 ) * 100) * $huella_p1.to_f).round(3) : 0) : 0
end

def puntaje_eje3_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 2], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  if @huella.consumo_anterior.to_f > 0 and @huella.consumo_actual.to_f > 0
    @huella.consumo_anterior.to_f > @huella.consumo_actual.to_f ? @hp2 = $huella_p2 * 100 : @hp2 = 0 if @huella.consumo_anterior or @huella.consumo_actual
  else
    @hp2 = 0
  end

  return valido ? @hp2 : 0
end

def puntaje_eje3_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 3], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
#  @s_electricas = selected(@huella.energia_electrica) if @huella.energia_electrica
  return valido ? (@huella.focos_ahorradores.to_f > 0 ? (((@huella.focos_ahorradores.to_f / @huella.total_focos.to_f ) * 100) * $huella_p3.to_f).round(3) : 0) : 0
end

def puntaje_eje3_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 4], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@huella.red_publica_agua == "SI" ? @hp4 = $huella_p4 * 100 : @hp4 = 0) : 0
end

def puntaje_eje3_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 5], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? ((((@huella.mantto_inst.to_f / 2 ) * 100) * $huella_p5.to_f).round(3)) : 0
end

def puntaje_eje3_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 6], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@huella.recip_residuos_solid == "SI" ? @hp6 = $huella_p6 * 100 : @hp6 = 0) : 0
end

def puntaje_eje3_p7
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 7], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@huella.sep_residuos_org_inorg == "SI" ? @hp7 = $huella_p7 * 100 : @hp7 = 0) : 0
end

def puntaje_eje3_p8
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 8], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@huella.elabora_compostas == "SI" ? @hp8 = $huella_p8 * 100 : @hp8 = 0) : 0
end

def puntaje_eje3_p9
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @huella = @diagnostico.huella if @diagnostico.huella
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 9], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje3 << e if catalogo_eje.clave == "EJE3"
  end
  @eje3.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  @s_inorganicos = multiple_selected_id(@huella.inorganicos) if @huella.inorganicos

  return valido ? ((@s_inorganicos.size == 1 and @huella.inorganicos[0]['clave'] == "NING") ? @hp9 = 0 : @hp9 = ptos_inorganicos(@s_inorganicos.size)) : 0
end

def puntaje_eje4_p2
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 2], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@consumo.conocen_lineamientos_grales == "SI" ? @cop2 = $consumo_p2 * 100 : @cop2 = 0) : 0
end

def puntaje_eje4_p3
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 3], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end

  return valido ? (@consumo.capacitacion_alim_bebidas == "SI" ? @cop3 = $consumo_p3 * 100 : @cop3 = 0) : 0
end

def puntaje_eje4_p4
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 4], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  @s_preparacions = multiple_selected(@consumo.preparacions) if @consumo.preparacions
  @s_utensilios = multiple_selected(@consumo.utensilios) if @consumo.utensilios
  @s_higienes = multiple_selected(@consumo.higienes) if @consumo.higienes
  @t_preparacions = Preparacion.all
  @t_utensilios = Utensilio.all
  @t_higiene = Higiene.all

  @preparacions = @s_preparacions.size > 0 ? (((@s_preparacions.size.to_f / @t_preparacions.size.to_f) * 100) * $consumo_p4) : 0
  @utensilios = @s_utensilios.size > 0 ? (((@s_utensilios.size.to_f / @t_utensilios.size.to_f) * 100) * $consumo_p4) : 0
  @higienes = @s_higienes.size > 0 ? (((@s_higienes.size.to_f / @t_higiene.size.to_f) * 100) * $consumo_p4) : 0

  return valido ? ((@s_preparacions.size + @s_utensilios.size + @s_higienes.size).to_f > 0 ? (@preparacions + @utensilios + @higienes).round(3) : 0) : 0
end

def puntaje_eje4_p5
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 5], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
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
  
  return valido ? ((@bebidas + @alimentos + @botanas + @reposterias).to_f > 0 ?  (@bebidas + @alimentos + @botanas + @reposterias) : 0) : 0
end

def puntaje_eje4_p6
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 6], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  @s_materials = multiple_selected(@consumo.materials) if @consumo.materials
  @m_recomendables = Material.find_all_by_tipo("RECOMENDABLES")
  @select_materials = 0
  @s_materials.each do |material|
    @select_materials+=1 if @m_recomendables.any? { |b| b[:clave] == material }
  end

  return valido ? ((((@select_materials.to_f / @s_materials.size.to_f)* 100)* $consumo_p6).round(3)) : 0
end

def puntaje_eje4_p7
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 7], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  @s_afisicas = selected(@consumo.frecuencia_afisica) if @consumo.frecuencia_afisica

  return valido ? (ptos_afisica(@s_afisicas)) : 0
end

def puntaje_eje4_p8
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  valido = false
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  @consumo = @diagnostico.consumo if @diagnostico.consumo
  @adjuntos = Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and numero_pregunta = ?", @user, @diagnostico.id, 8], :order => "eje_id")
  @adjuntos.each do |e|
      catalogo_eje = CatalogoEje.find(e.eje_id)
      @eje4 << e if catalogo_eje.clave == "EJE3"
  end
  @eje4.each do |ad|
    if ad.validado
      valido = true
      break;
    end
  end
  minutos_activacion_fisica = (@consumo.minutos_activacion_fisica) ? @consumo.minutos_activacion_fisica : 0
  
  return valido ? (ptos_minutos(minutos_activacion_fisica > 30 ? 30 : @consumo.minutos_activacion_fisica)) : 0
end

def puntaje_total_eje1
  return puntaje_eje1_p1 + puntaje_eje1_p2 + puntaje_eje1_p3
end



def puntaje_total_evidencias
  return puntaje_total_eje1 + puntaje_total_eje2 + puntaje_total_eje3 + puntaje_total_eje4
end

def puntaje_total_novidencias
#### Aqui hacemos una consulta para obtener el ppuntaje de las no evidencias
end

end
