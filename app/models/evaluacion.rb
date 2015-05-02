include Functions
class Evaluacion < ActiveRecord::Base

  belongs_to :user
  belongs_to :proyecto
  belongs_to :diagnostico

  def before_save
    self.observaciones.upcase! unless self.observaciones.nil?
  end

###--- DESARROLLO DE COMPETENCIAS
def puntaje_eje1_p1(tipo=nil,avance=nil)
  valido = false
  docentes_capacitados=0

  eje1 = CatalogoEje.find_by_clave("EJE1")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
     @competencia_proyecto = @proyecto.competencia if @proyecto.competencia
     @competencia_diagnostico = @proyecto.diagnostico.competencia if @proyecto.diagnostico.competencia
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     docentes_capacitados += (@competencia_proyecto.dctes_cap_salud.to_i + @competencia_proyecto.dctes_cap_ma.to_i + @competencia_proyecto.dctes_cap_ambos.to_i) if @competencia_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje1.id, 1, true]).to_i > 0
       docentes_capacitados += (@competencia_diagnostico.dctes_cap_salud.to_i + @competencia_diagnostico.dctes_cap_ma.to_i + @competencia_diagnostico.dctes_cap_ambos.to_i) if @competencia_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @competencia_diagnostico = @diagnostico.competencia if @diagnostico.competencia
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje1.id, 1, true]).to_i > 0
      docentes_capacitados += (@competencia_diagnostico.dctes_cap_salud.to_i + @competencia_diagnostico.dctes_cap_ma.to_i + @competencia_diagnostico.dctes_cap_ambos.to_i) if @competencia_diagnostico
    end
  end

  if docentes_capacitados > 0
    valido = evidencia_valida?(eje1.id, 1, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje1.id, 1, nil, @proyecto, avance) if @proyecto && avance
    @eje1_p1 = (((docentes_capacitados / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p1).round(3)
  end

  return valido ? @eje1_p1 : 0
end

def puntaje_eje1_p2(tipo=nil,avance=nil)
  valido = false
  docentes_aplican_conocimiento=0
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
     @competencia_proyecto = @proyecto.competencia if @proyecto.competencia
     @competencia_diagnostico = @proyecto.diagnostico.competencia if @proyecto.diagnostico.competencia
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     docentes_aplican_conocimiento += (@competencia_proyecto.dctes_aplican_conocimto.to_i) if @competencia_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje1.id, 2, true]).to_i > 0
       docentes_aplican_conocimiento += (@competencia_diagnostico.dctes_aplican_conocimto.to_i) if @competencia_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @competencia_diagnostico = @diagnostico.competencia if @diagnostico.competencia
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje1.id, 2, true]).to_i > 0
      docentes_aplican_conocimiento += (@competencia_diagnostico.dctes_aplican_conocimto.to_i) if @competencia_diagnostico
    end
  end

  if docentes_aplican_conocimiento.to_i > 0
    valido = evidencia_valida?(eje1.id, 1, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje1.id, 1, nil, @proyecto, avance) if @proyecto && avance
    @eje1_p2 = (((docentes_aplican_conocimiento.to_f / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p2).round(3)
  end

  return valido ? @eje1_p2 : 0
end

def puntaje_eje1_p3(tipo=nil,avance=nil)
  valido = false
  docentes_involucran_actividades = 0
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
     @competencia_proyecto = @proyecto.competencia if @proyecto.competencia
     @competencia_diagnostico = @proyecto.diagnostico.competencia if @proyecto.diagnostico.competencia
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     docentes_involucran_actividades += (@competencia_proyecto.dctes_invol_act.to_i) if @competencia_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje1.id, 3, true]).to_i > 0
       docentes_involucran_actividades += (@competencia_diagnostico.dctes_invol_act.to_i) if @competencia_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @competencia_diagnostico = @diagnostico.competencia if @diagnostico.competencia
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje1.id, 3, true]).to_i > 0
      docentes_involucran_actividades += (@competencia_diagnostico.dctes_invol_act.to_i) if @competencia_diagnostico
    end
  end

  if docentes_involucran_actividades.to_i > 0
    valido = evidencia_valida?(eje1.id, 3, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje1.id, 3, nil, @proyecto, avance) if @proyecto && avance
    @eje1_p3 = (((docentes_involucran_actividades.to_f / @escuela.total_personal_docente.to_f ) * 100) * $competencia_p3).round(3)
  end

  return valido ? @eje1_p3 : 0
end

def puntaje_eje1_p4(tipo=nil,avance=nil)
  valido = false
  alumnos_capacitacion_docente = 0
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if tipo == "proyecto"
     @proyecto = Proyecto.find(self.proyecto_id)
     @competencia_proyecto = @proyecto.competencia if @proyecto.competencia
     @competencia_diagnostico = @proyecto.diagnostico.competencia if @proyecto.diagnostico.competencia
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     alumnos_capacitacion_docente += (@competencia_proyecto.alumn_cap_dctes.to_i) if @competencia_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje1.id, 4, true]).to_i > 0
       alumnos_capacitacion_docente += (@competencia_diagnostico.alumn_cap_dctes.to_i) if @competencia_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @competencia_diagnostico = @diagnostico.competencia if @diagnostico.competencia
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje1.id, 4, true]).to_i > 0
      alumnos_capacitacion_docente += (@competencia_diagnostico.alumn_cap_dctes.to_i) if @competencia_diagnostico
    end
  end
  @user = User.find_by_login(@escuela.clave) if @escuela

  if alumnos_capacitacion_docente.to_i > 0
    valido = evidencia_valida?(eje1.id, 4, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje1.id, 4, nil, @proyecto, avance) if @proyecto && avance
    @eje1_p4 = (((alumnos_capacitacion_docente.to_f / (@escuela.alu_hom.to_i + @escuela.alu_muj.to_i) ).to_f * 100) * $competencia_p4).round(3)
  end

  return valido ? @eje1_p4 : 0
end

def puntaje_eje1_p5(tipo=nil,avance=nil)
  valido = false
  alumnos_capacitacion_dep = 0
  eje1 = CatalogoEje.find_by_clave("EJE1")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
     @competencia_proyecto = @proyecto.competencia if @proyecto.competencia
     @competencia_diagnostico = @proyecto.diagnostico.competencia if @proyecto.diagnostico.competencia
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     alumnos_capacitacion_dep += (@competencia_proyecto.alumn_cap_salud.to_i + @competencia_proyecto.alumn_cap_ma.to_i + @competencia_proyecto.alumn_cap_ambos.to_i) if @competencia_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje1.id, 5, true]).to_i > 0
       alumnos_capacitacion_dep += (@competencia_diagnostico.alumn_cap_salud.to_i + @competencia_diagnostico.alumn_cap_ma.to_i + @competencia_diagnostico.alumn_cap_ambos.to_i) if @competencia_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @competencia_diagnostico = @diagnostico.competencia if @diagnostico.competencia
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje1.id, 5, true]).to_i > 0
      alumnos_capacitacion_dep += (@competencia_diagnostico.alumn_cap_salud.to_i + @competencia_diagnostico.alumn_cap_ma.to_i + @competencia_diagnostico.alumn_cap_ambos.to_i) if @competencia_diagnostico
    end
  end

  if alumnos_capacitacion_dep.to_i > 0
    valido = evidencia_valida?(eje1.id, 5, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje1.id, 5, nil, @proyecto, avance) if @proyecto && avance
    @eje1_p5 = (((alumnos_capacitacion_dep.to_f / (@escuela.alu_hom.to_f + @escuela.alu_muj.to_f) ).to_f * 100) * $competencia_p5).round(3)
  end

  return valido ? @eje1_p5 : 0
end

###--- ENTORNO SALUDABLE
def puntaje_eje2_p2(tipo=nil,avance=nil)
  valido = false
  numero_espacios = 0
  eje2 = CatalogoEje.find_by_clave("EJE2")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
     @entorno_proyecto = @proyecto.entorno if @proyecto.entorno
     @entorno_diagnostico = @proyecto.diagnostico.entorno if @proyecto.diagnostico.entorno
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     numero_espacios += (EscuelasEspacio.count(:id, :conditions => ["entorno_id = ?", @entorno_proyecto.id])).to_i if @entorno_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje2.id, 2, true]).to_i > 0
       numero_espacios += (EscuelasEspacio.count(:id, :conditions => ["entorno_id = ?", @entorno_diagnostico.id])).to_i if @entorno_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @entorno_diagnostico = @diagnostico.entorno if @diagnostico.entorno
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje2.id, 2, true]).to_i > 0
      numero_espacios += (EscuelasEspacio.count(:id, :conditions => ["entorno_id = ?", @entorno_diagnostico.id])).to_i if @entorno_diagnostico
    end
  end

  if numero_espacios.to_i > 0
    valido = evidencia_valida?(eje2.id, 2, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje2.id, 2, nil, @proyecto, avance) if @proyecto && avance
    @eje2_p2 = (((numero_espacios.to_f / Espacio.all.size.to_f) * 100) * $entorno_p2).round(3)
  end
  return valido ? @eje2_p2 : 0
end

def puntaje_eje2_p3(tipo=nil,avance=nil)
  valido = false
  reforesta = ""
  eje2 = CatalogoEje.find_by_clave("EJE2")
  if tipo == "proyecto"
     @proyecto = Proyecto.find(self.proyecto_id)
     @entorno_proyecto = @proyecto.entorno if @proyecto.entorno
     @entorno_diagnostico = @proyecto.diagnostico.entorno if @proyecto.diagnostico.entorno
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     reforesta = @entorno_proyecto.escuela_reforesta
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @entorno_diagnostico = @diagnostico.entorno if @diagnostico.entorno
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    reforesta = @entorno_diagnostico.escuela_reforesta
  end

  if reforesta == "SI"
    valido = evidencia_valida?(eje2.id, 3, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje2.id, 3, nil, @proyecto, avance) if @proyecto && avance
    @eje2_p3 = $entorno_p3 * 100
  end
  return valido ? @eje2_p3 : 0
end

def puntaje_eje2_p5(tipo=nil,avance=nil)
  valido = false
  @s_acciones = []
  eje2 = CatalogoEje.find_by_clave("EJE2")
  if tipo == "proyecto"
     @proyecto = Proyecto.find(self.proyecto_id)
     @entorno_proyecto = @proyecto.entorno if @proyecto.entorno
     @entorno_diagnostico = @proyecto.diagnostico.entorno if @proyecto.diagnostico.entorno
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela

     @s_acciones << multiple_selected(@entorno_proyecto.acciones) if @entorno_proyecto
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje2.id, 5, true]).to_i > 0
       @s_acciones << multiple_selected(@entorno_diagnostico.acciones) if @entorno_diagnostico
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @entorno_diagnostico = @diagnostico.entorno if @diagnostico.entorno
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela

    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje2.id, 5, true]).to_i > 0
      @s_acciones << multiple_selected(@entorno_diagnostico.acciones) if @entorno_diagnostico
    end
  end

  unless @s_acciones.include?("NING")
    valido = evidencia_valida?(eje2.id, 5, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje2.id, 5, nil, @proyecto, avance) if @proyecto && avance

    if @escuela.nivel_descripcion == "BACHILLERATO"
      num_acciones = Accione.count(:id, :conditions => ["clave not in ('AC02', 'NING')"])
      @eje2_p5 = (((@s_acciones.size.to_f / num_acciones.to_i)* 100) * $entorno_p5).round(3)
    else
      num_acciones = Accione.count(:id, :conditions => ["clave not in ('AC00', 'AC01', 'NING')"])
      @eje2_p5 = (((@s_acciones.size.to_f / num_acciones.to_i)* 100) * $entorno_p5).round(3)
    end
  end

  return valido ? @eje2_p5 : 0
end

##-- HUELLA ECOLOGICA
def puntaje_eje3_p1(tipo=nil,avance=nil)
  valido = false
  ahorra_energia = ""
  eje3 = CatalogoEje.find_by_clave("EJE3")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
    @huella_proyecto = @proyecto.huella if @proyecto.huella
    @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
    @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
    @user = User.find_by_login(@escuela.clave) if @escuela
    ahorra_energia = @huella_proyecto.capacitacion_ahorro_energia
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    ahorra_energia = @huella_diagnostico.capacitacion_ahorro_energia
  end

  if ahorra_energia == "SI"
    valido = evidencia_valida?(eje3.id, 1, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje3.id, 1, nil, @proyecto, avance) if @proyecto && avance
    @eje3_p1 = ($huella_p1 * 100).to_f
  end

  return valido ? @eje3_p1 : 0
end

def puntaje_eje3_p3(tipo=nil,avance=nil)
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
    @huella_proyecto = @proyecto.huella if @proyecto.huella
    @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
    @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
    @user = User.find_by_login(@escuela.clave) if @escuela
    @eje3_p3 = (((@huella_proyecto.focos_ahorradores.to_f / @huella_proyecto.total_focos.to_f ) * 100) * $huella_p3).round(3) if @huella_proyecto.focos_ahorradores.to_f > 0
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    @eje3_p3 = (((@huella_diagnostico.focos_ahorradores.to_f / @huella_diagnostico.total_focos.to_f ) * 100) * $huella_p3).round(3) if @huella_diagnostico.focos_ahorradores.to_f > 0
  end

  return @eje3_p3 ? @eje3_p3 : 0
end

def puntaje_eje3_p5(tipo=nil,avance=nil)
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
    @huella_proyecto = @proyecto.huella if @proyecto.huella
    @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
    @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
    @user = User.find_by_login(@escuela.clave) if @escuela
    @eje3_p5 = (((@huella_proyecto.mantto_inst.to_f / 2 ) * 100) * $huella_p5).round(3)
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    @eje3_p5 = (((@huella_diagnostico.mantto_inst.to_f / 2 ) * 100) * $huella_p5).round(3)
  end

  return @eje3_p5 ? @eje3_p5 : 0
end

def puntaje_eje3_p7(tipo=nil,avance=nil)
  valido = false
  separa_residuos = ""
  eje3 = CatalogoEje.find_by_clave("EJE3")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
    @huella_proyecto = @proyecto.huella if @proyecto.huella
    @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
    @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
    @user = User.find_by_login(@escuela.clave) if @escuela
    separa_residuos = @huella_proyecto.sep_residuos_org_inorg
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    separa_residuos = @huella_diagnostico.sep_residuos_org_inorg
  end

  if separa_residuos == "SI"
    valido = evidencia_valida?(eje3.id, 7, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje3.id, 7, nil, @proyecto, avance) if @proyecto && avance
    @eje3_p7 = ($huella_p7 * 100).to_f
  end
  return valido ? @eje3_p7 : 0
end

def puntaje_eje3_p8(tipo=nil,avance=nil)
  valido = false
  elabora_compostas = ""
  eje3 = CatalogoEje.find_by_clave("EJE3")
  if tipo == "proyecto"
    @proyecto = Proyecto.find(self.proyecto_id)
    @huella_proyecto = @proyecto.huella if @proyecto.huella
    @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
    @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
    @user = User.find_by_login(@escuela.clave) if @escuela
    elabora_compostas = @huella_proyecto.elabora_compostas
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    elabora_compostas = @huella_diagnostico.elabora_compostas
  end

  if elabora_compostas == "SI"
    valido = evidencia_valida?(eje3.id, 8, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje3.id, 8, nil, @proyecto, avance) if @proyecto && avance
    @eje3_p8 = ($huella_p8 * 100).to_f
  end

  return valido ? @eje3_p8 : 0
end

def puntaje_eje3_p9(tipo=nil,avance=nil)
  valido = false
  @s_inorganicos = []
  eje3 = CatalogoEje.find_by_clave("EJE3")
  if tipo == "proyecto"
     @proyecto = Proyecto.find(self.proyecto_id)
     @huella_proyecto = @proyecto.huella if @proyecto.huella
     @huella_diagnostico = @proyecto.diagnostico.huella if @proyecto.diagnostico.huella
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela

     @s_inorganicos << multiple_selected(@huella_proyecto.inorganicos) if @huella_proyecto.inorganicos
     if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @proyecto.diagnostico.id, eje3.id, 9, true]).to_i > 0
       @s_inorganicos << multiple_selected(@huella_diagnostico.inorganicos) if @huella_diagnostico.inorganicos
     end
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @huella_diagnostico = @diagnostico.huella if @diagnostico.huella
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela

    if Adjunto.count(:id, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ? and validado = ?", @user, @diagnostico.id, eje3.id, 9, true]).to_i > 0
      @s_inorganicos << multiple_selected(@huella_diagnostico.inorganicos) if @huella_diagnostico.inorganicos
    end
  end

  unless @s_inorganicos.include?("NING")
    valido = evidencia_valida?(eje3.id, 9, @diagnostico) if @diagnostico
    valido ||= evidencia_valida?(eje3.id, 9, nil, @proyecto, avance) if @proyecto && avance
    @eje3_p9 = ptos_inorganicos(@s_inorganicos.size.to_i)
  end

  return valido ? @eje3_p9 : 0
end


##-- CONSUMO RESPONSABLE / SALUDABLE

def puntaje_eje4_p2(tipo=nil, avance=nil)
  valido = false
  eje4 = CatalogoEje.find_by_clave("EJE4")
  conocen_lineamientos_grales=""
  if tipo == "proyecto"
     @proyecto = Proyecto.find(self.proyecto_id)
     @consumo = @proyecto.consumo if @proyecto.consumo
     @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
     @user = User.find_by_login(@escuela.clave) if @escuela
     conocen_lineamientos_grales =  (@consumo.conocen_lineamientos_grales == "SI")? true : false
  else
    @diagnostico = Diagnostico.find(self.diagnostico_id)
    @consumo = @diagnostico.consumo if @diagnostico.consumo
    @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
    @user = User.find_by_login(@escuela.clave) if @escuela
    conocen_lineamientos_grales =  (@consumo.conocen_lineamientos_grales == "SI")? true : false
  end

  if @consumo && conocen_lineamientos_grales == "SI"
    @eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and numero_pregunta = ? and avance = ?", @user, @proyecto.id, eje4.id, 2, avance], :order => "eje_id") if tipo=="proyecto" && avance
    @eje4 ||= Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje4.id, 2], :order => "eje_id")
    @eje4.each do |ad|
      if ad.validado
        valido = true
        break
      end
    end
    @eje4_p2 = $consumo_p2 * 100
  end
  return valido ? @eje4_p2 : 0
end



def puntaje_eje4_p3(tipo=nil, avance=nil)
    valido = false
    eje4 = CatalogoEje.find_by_clave("EJE4")
    capacitacion_alim_bebidas=""
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @consumo = @proyecto.consumo if @proyecto.consumo
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitacion_alim_bebidas =  (@consumo.capacitacion_alim_bebidas == "SI")? true : false
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @consumo = @diagnostico.consumo if @diagnostico.consumo
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitacion_alim_bebidas =  (@consumo.capacitacion_alim_bebidas == "SI")? true : false
    end

  if @consumo && capacitacion_alim_bebidas
    @eje4 = Adjunto.find(:all, :conditions => ["user_id = ? and proyecto_id = ? and eje_id = ? and numero_pregunta = ? and avance = ?", @user, @proyecto.id, eje4.id, 3, avance], :order => "eje_id") if tipo=="proyecto" && avance
    @eje4 ||= Adjunto.find(:all, :conditions => ["user_id = ? and diagnostico_id = ? and eje_id = ? and numero_pregunta = ?", @user, @diagnostico.id, eje4.id, 3], :order => "eje_id")
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

def puntaje_eje4_p4(tipo=nil, avance=nil)
    @eje4_p4 = @s_preparacions = @s_utensilios = @s_higienes = 0
    if tipo == "proyecto"
        @proyecto = Proyecto.find(self.proyecto_id)
        @consumo_proyecto = @proyecto.consumo if @proyecto.consumo
        @consumo_diagnostico = @proyecto.diagnostico.consumo if @proyecto.diagnostico.consumo
        @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
        @user = User.find_by_login(@escuela.clave) if @escuela
        #### Proyecto ###
        @s_preparacions += multiple_selected(@consumo_proyecto.preparacions).size if @consumo_proyecto && @consumo_proyecto.preparacions
        @s_utensilios += multiple_selected(@consumo_proyecto.utensilios).size if @consumo_proyecto && @consumo_proyecto.utensilios
        @s_higienes += multiple_selected(@consumo_proyecto.higienes).size if @consumo_proyecto && @consumo_proyectos.higienes
        #### Diagnostico #
        @s_preparacions += multiple_selected(@consumo_diagnostico.preparacions).size if @consumo_diagnostico && @consumo_diagnostico.preparacions
        @s_utensilios += multiple_selected(@consumo_diagnostico.utensilios).size if @consumo_diagnostico && @consumo_diagnostico.utensilios
        @s_higienes += multiple_selected(@consumo_diagnostico.higienes).size if @consumo_diagnostico && @consumo_diagnostico.higienes
    else
        @diagnostico = Diagnostico.find(self.diagnostico_id)
        @consumo_diagnostico = @diagnostico.consumo if @diagnostico.consumo
        @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
        @user = User.find_by_login(@escuela.clave) if @escuela
        #### Diagnostico #
        @s_preparacions += multiple_selected(@consumo_diagnostico.preparacions).size if @consumo_diagnostico && @consumo_diagnostico.preparacions
        @s_utensilios += multiple_selected(@consumo_diagnostico.utensilios).size if @consumo_diagnostico && @consumo_diagnostico.utensilios
        @s_higienes += multiple_selected(@consumo_diagnostico.higienes).size if @consumo_diagnostico && @consumo_diagnostico.higienes
    end

  if @consumo_diagnostico || @consumo_proyecto
    @t_preparacions = Preparacion.all
    @t_utensilios = Utensilio.all
    @t_higiene = Higiene.all

    @preparacions = @s_preparacions > 0 ? (((@s_preparacions.to_f / @t_preparacions.size.to_f) * 100) * $consumo_p4) : 0
    @utensilios = @s_utensilios > 0 ? (((@s_utensilios.to_f / @t_utensilios.size.to_f) * 100) * $consumo_p4) : 0
    @higienes = @s_higienes > 0 ? (((@s_higienes.to_f / @t_higiene.size.to_f) * 100) * $consumo_p4) : 0
    if (@s_preparacions.size + @s_utensilios.size + @s_higienes.size).to_f > 0
      @eje4_p4 = (@preparacions.to_f + @utensilios.to_f + @higienes.to_f).round(3)
    else
      @eje4_p4 = 0
    end
  end

  return @eje4_p4
end

def puntaje_eje4_p5(tipo=nil, avance=nil)
     @eje4_p5=0
     @s_bebidas = @s_alimentos = @s_botanas = @s_reposterias = Array.new
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @consumo_proyecto = @proyecto.consumo if @proyecto.consumo
      @consumo_diagnostico = @proyecto.diagnostico.consumo if @proyecto.diagnostico.consumo
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      ### Proyecto ###
      @s_bebidas << multiple_selected(@consumo_proyecto.bebidas) if @consumo_proyecto.bebidas
      @s_alimentos << multiple_selected(@consumo_proyecto.alimentos) if @consumo_proyecto.alimentos
      @s_botanas << multiple_selected(@consumo_proyecto.botanas) if @consumo_proyecto.botanas
      @s_reposterias << multiple_selected(@consumo_proyecto.reposterias) if @consumo_proyecto.reposterias
      ## Diagnostico ###
      @s_bebidas << multiple_selected(@consumo_proyecto.bebidas) if @consumo_diagnostico && @consumo_diagnostico.bebidas
      @s_alimentos << multiple_selected(@consumo_proyecto.alimentos) if @consumo_diagnostico && @consumo_diagnostico.alimentos
      @s_botanas << multiple_selected(@consumo_proyecto.botanas) if @consumo_diagnostico && @consumo_diagnostico.botanas
      @s_reposterias << multiple_selected(@consumo_proyecto.reposterias) if @consumo_diagnostico && @consumo_diagnostico.reposterias
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @consumo_diagnostico = @diagnostico.consumo if @diagnostico.consumo
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      ## Diagnostico ###
      @s_bebidas << multiple_selected(@consumo_diagnostico.bebidas) if @consumo_diagnostico && @consumo_diagnostico.bebidas
      @s_alimentos << multiple_selected(@consumo_diagnostico.alimentos) if @consumo_diagnostico && @consumo_diagnostico.alimentos
      @s_botanas << multiple_selected(@consumo_diagnostico.botanas) if @consumo_diagnostico && @consumo_diagnostico.botanas
      @s_reposterias << multiple_selected(@consumo_diagnostico.reposterias) if @consumo_diagnostico && @consumo_diagnostico.reposterias
    end

  if @consumo_diagnostico || @consumo_proyecto
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
    @eje4_p5 = (@bebidas + @alimentos + @botanas + @reposterias).to_f
  else
    @eje4_p5 = 0
  end
  end

  return @eje4_p5
end

def puntaje_eje4_p6(tipo=nil, avance=nil)
      @eje4_p6=0
     @s_materials = Array.new
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @consumo_proyecto = @proyecto.consumo if @proyecto.consumo
      @consumo_diagnostico = @proyecto.diagnostico.consumo if @proyecto.diagnostico.consumo
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      ### Proyecto ###
      @s_materials << multiple_selected(@consumo_proyecto.materials) if @consumo_proyecto.materials
      ## Diagnostico ###
      @s_materials << multiple_selected(@consumo_diagnostico.materials) if @consumo_diagnostico && @consumo_diagnostico.materials
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @consumo_diagnostico = @diagnostico.consumo if @diagnostico.consumo
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      ## Diagnostico ###
      @s_materials << multiple_selected(@consumo_diagnostico.materials) if @consumo_diagnostico && @consumo_diagnostico.materials
    end

  if @consumo_diagnostico || @consumo_proyecto
    if @s_materials.size.to_i > 0
      @m_recomendables = Material.find_all_by_tipo("RECOMENDABLES")
      @select_materials = 0
      @s_materials.each do |material|
        @select_materials+=1 if @m_recomendables.any? { |b| b[:clave] == material }
      end
      @eje4_p6 = (((@select_materials.to_f / @s_materials.size.to_f)* 100)* $consumo_p6).round(3).to_f
    end
  end

  return @eje4_p6 ? @eje4_p6 : 0
end

def puntaje_eje4_p7(tipo=nil, avance=nil)
  valido = false
  eje4 = CatalogoEje.find_by_clave("EJE4")
  @s_afisicas= Array.new
  if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @consumo_proyecto = @proyecto.consumo if @proyecto.consumo
      @consumo_diagnostico = @proyecto.diagnostico.consumo if @proyecto.diagnostico.consumo
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      @s_afisicas << selected(@consumo_proyecto.frecuencia_afisica) if @consumo_proyecto.frecuencia_afisica
      @s_afisicas << selected(@consumo_diagnostico.frecuencia_afisica) if @consumo_diagnostico && @consumo_diagnostico.frecuencia_afisica
  else
     @diagnostico = Diagnostico.find(self.diagnostico_id)
      @consumo_diagnostico = @diagnostico.consumo if @diagnostico.consumo
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      @s_afisicas << selected(@consumo_diagnostico.frecuencia_afisica) if @consumo_diagnostico && @consumo_diagnostico.frecuencia_afisica
  end

  if @consumo_diagnostico || @consumo_proyecto
    @eje4_p7 = ptos_afisica(@s_afisicas).to_f
    valido = evidencia_valida?(4, 7, @diagnostico, @proyecto, avance )
  end
    return valido ? @eje4_p7 : 0
end

def puntaje_eje4_p8(tipo=nil, avance=nil)
  @eje4_p8 = minutos_activacion_fisica =0
  if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @consumo_proyecto = @proyecto.consumo if @proyecto.consumo
      @consumo_diagnostico = @proyecto.diagnostico.consumo if @proyecto.diagnostico.consumo
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      minutos_activacion_fisica = (@consumo_proyecto.minutos_activacion_fisica) ? @consumo_proyecto.minutos_activacion_fisica : 0
  else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @consumo_diagnostico = @diagnostico.consumo if @diagnostico.consumo
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      minutos_activacion_fisica = (@consumo_diagnostico.minutos_activacion_fisica) ? @consumo_diagnostico.minutos_activacion_fisica : 0
  end

  if @consumo_diagnostico || @consumo_proyecto
    if minutos_activacion_fisica > 30
      @eje4_p8 = ptos_minutos(30).to_f
    else
      @eje4_p8 = ptos_minutos(minutos_activacion_fisica).to_f
    end
  end

  return @eje4_p8
end

##-- PARTICIPACION COMUNITARIA

def puntaje_eje5_p2(tipo=nil, avance=nil)
  valido = false
  eje5 = CatalogoEje.find_by_clave("EJE5")
  num_padres_familia= capacitacion_salud_ma = 0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      num_padres_familia+=@participacion_proyecto.num_padres_familia.to_i if @participacion_proyecto && @participacion_proyecto.num_padres_familia
      num_padres_familia+=@participacion_diagnostico.num_padres_familia.to_i if @participacion_diagnostico && @participacion_diagnostico.num_padres_familia
      capacitacion_salud_ma+=@participacion_proyecto.capacitacion_salud_ma.to_f if @participacion_proyecto && @participacion_proyecto.capacitacion_salud_ma
      capacitacion_salud_ma+=@participacion_diagnostico.capacitacion_salud_ma.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_salud_ma
  else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      num_padres_familia+=@participacion_diagnostico.num_padres_familia.to_i if @participacion_diagnostico && @participacion_diagnostico.num_padres_familia
      capacitacion_salud_ma+=@participacion_diagnostico.capacitacion_salud_ma.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_salud_ma
  end

 if num_padres_familia > 0
    valido = evidencia_valida?(eje5.id, 2, @diagnostico, @proyecto, avance)
    @eje5_p2 = (((capacitacion_salud_ma.to_f / num_padres_familia.to_f ) * 100) * $participacion_p2.to_f).round(3)
  end

  return valido ? @eje5_p2 : 0
end

def puntaje_eje5_p3(tipo=nil, avance=nil)
  valido = false
  eje5 = CatalogoEje.find_by_clave("EJE5")
   @eje5_p3 = capacitacion_salud = capacitacion_medioambiente =  0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitacion_salud+=@participacion_proyecto.capacitacion_salud.to_f if @participacion_proyecto && @participacion_proyecto.capacitacion_salud
      capacitacion_salud+=@participacion_diagnostico.capacitacion_salud.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_salud
      capacitacion_medioambiente+=@participacion_proyecto.capacitacion_medioambiente.to_f if @participacion_proyecto && @participacion_proyecto.capacitacion_medioambiente
      capacitacion_medioambiente+=@participacion_diagnostico.capacitacion_medioambiente.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_medioambiente
  else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitacion_salud+=@participacion_diagnostico.capacitacion_salud.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_salud
      capacitacion_medioambiente+=@participacion_diagnostico.capacitacion_medioambiente.to_f if @participacion_diagnostico && @participacion_diagnostico.capacitacion_medioambiente
  end

 if (capacitacion_salud.to_i + capacitacion_medioambiente.to_i) > 0
    valido = evidencia_valida?(eje5.id, 3, @diagnostico, @proyecto, avance)
    @eje5_p3 = ptos_capacitaciones(capacitacion_salud) +  ptos_capacitaciones(capacitacion_medioambiente)
  end

  return valido ? @eje5_p3 : 0
end

def puntaje_eje5_p4(tipo=nil, avance=nil)
  valido = false
  eje5 = CatalogoEje.find_by_clave("EJE5")
   @eje5_p4 = capacitaciones_padres =  0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitaciones_padres += CapacitacionPadre.sum(:numero_capacitaciones, :conditions => ["participacion_id = ?", @participacion_proyecto.id ]) if @participacion_proyecto
      capacitaciones_padres += CapacitacionPadre.sum(:numero_capacitaciones, :conditions => ["participacion_id = ?", @participacion_diagnostico.id ]) if @participacion_diagnostico
  else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      capacitaciones_padres += CapacitacionPadre.sum(:numero_capacitaciones, :conditions => ["participacion_id = ?", @participacion_diagnostico.id ]) if @participacion_diagnostico
  end

  if capacitaciones_padres.to_i > 0
    valido = evidencia_valida?(eje5.id, 4, @diagnostico, @proyecto, avance)
    @eje5_p4 = ptos_proyectos(capacitaciones_padres.to_i)
  end
  return valido ? @eje5_p4 : 0
end

def puntaje_eje5_p5(tipo=nil, avance=nil)
    valido = false
    eje5 = CatalogoEje.find_by_clave("EJE5")
    @eje5_p5 = proyectos =  0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_proyecto.id, 'MEDIOAMBIENTE']) if @participacion_proyecto
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'MEDIOAMBIENTE']) if @participacion_diagnostico
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'MEDIOAMBIENTE']) if @participacion_diagnostico
    end

    if proyectos.to_i > 0
      valido = evidencia_valida?(eje5.id, 5, @diagnostico, @proyecto, avance)
      @eje5_p5 = ptos_proyectos(proyectos.to_i)
    else
      clean_adjuntos(5,@diagnostico.id, 5) if @diagnostico
    end
    return valido ? @eje5_p5 : 0
end

def puntaje_eje5_p6(tipo=nil, avance=nil)
    valido = false
    eje5 = CatalogoEje.find_by_clave("EJE5")
    @eje5_p6 = proyectos =  0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_proyecto.id, 'SALUD']) if @participacion_proyecto
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'SALUD']) if @participacion_diagnostico
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'SALUD']) if @participacion_diagnostico
    end

    if proyectos.to_i > 0
      valido = evidencia_valida?(eje5.id, 6, @diagnostico, @proyecto, avance)
      @eje5_p6 = ptos_proyectos(proyectos.to_i)
    else
      clean_adjuntos(5,@diagnostico.id, 6) if @diagnostico
    end
    return valido ? @eje5_p6 : 0
end

def puntaje_eje5_p7(tipo=nil, avance=nil)
    valido = false
    eje5 = CatalogoEje.find_by_clave("EJE5")
    @eje5_p7 = proyectos =  0
    if tipo == "proyecto"
      @proyecto = Proyecto.find(self.proyecto_id)
      @participacion_proyecto = @proyecto.participacion if @proyecto.participacion
      @participacion_diagnostico = @proyecto.diagnostico.participacion if @proyecto.diagnostico.participacion
      @escuela = Escuela.find_by_clave(@proyecto.diagnostico.escuela.clave) if @proyecto
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_proyecto.id, 'DEPENDENCIAS']) if @participacion_proyecto
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'DEPENDENCIAS']) if @participacion_diagnostico
    else
      @diagnostico = Diagnostico.find(self.diagnostico_id)
      @participacion_diagnostico = @diagnostico.participacion if @diagnostico.participacion
      @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
      @user = User.find_by_login(@escuela.clave) if @escuela
      proyectos += Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia = ?", @participacion_diagnostico.id, 'DEPENDENCIAS']) if @participacion_diagnostico
    end

    if proyectos.to_i > 0
      valido = evidencia_valida?(eje5.id, 7, @diagnostico, @proyecto, avance)
      @eje5_p7 = ptos_proyectos(proyectos.to_i)
    else
      clean_adjuntos(5,@diagnostico.id, 7) if @diagnostico
    end
    return valido ? @eje5_p7 : 0
end

###--- OBTENIDOS AVANCE ---
def puntaje_avance_eje(avance, num_eje, num_actividad)
  valido = false
  @diagnostico = Diagnostico.find(self.diagnostico_id)
  @proyecto = Proyecto.find(:first, :conditions => ["diagnostico_id = ?", @diagnostico.id]) if @diagnostico
  @escuela = Escuela.find_by_clave(@diagnostico.escuela.clave) if @diagnostico
  @user = User.find_by_login(@escuela.clave) if @escuela
  eje = CatalogoEje.find_by_clave("EJE#{num_eje}")
#  @adjunto = Adjunto.find(:all, :conditions => ["user_id = ? AND diagnostico_id = ? AND eje_id = ? AND avance = ? AND numero_actividad = ?", @user, @diagnostico.id, eje.id, avance, num_actividad], :order => "eje_id")
  @adjunto = Adjunto.find(:all, :select => "adjuntos.*",  :joins => "adjuntos, ejes e, catalogo_ejes ce", :conditions => ["adjuntos.eje_id = e.id AND e.catalogo_eje_id = ce.id AND adjuntos.avance = ? AND adjuntos.proyecto_id = ? AND ce.clave = ? AND adjuntos.numero_actividad = ?", avance, @proyecto.id, eje.clave, num_actividad])
  @adjunto.each do |ad|
    if ad.validado
      valido = true
      break
    end
  end

  return valido ? $avance_actividad : 0
end

###--- OBTENIDOS EJES ---
def puntaje_total_eje1
  return (($competencia_p1.to_f + $competencia_p2.to_f + $competencia_p3.to_f + $competencia_p4.to_f + $competencia_p5.to_f) * 100).round(3)
end

def puntaje_total_eje2
  return (($entorno_p2.to_f + $entorno_p3.to_f + $entorno_p5.to_f) * 100).to_f.round(3)
end

def puntaje_total_eje3
  return (($huella_p1.to_f + $huella_p3.to_f + $huella_p5.to_f + $huella_p7.to_f + $huella_p8.to_f + $huella_p9.to_f)*100).round(3)
end

def puntaje_total_eje4
  return (($consumo_p2.to_f + $consumo_p3.to_f + ($consumo_p4.to_f * 3) + ($consumo_p5.to_f * 4) + $consumo_p6.to_f + $consumo_p7.to_f + $consumo_p8.to_f)*100 ).round(3)
end

def puntaje_total_eje5
  return (($participacion_p2.to_f + $participacion_p3.to_f + $participacion_p4.to_f + $participacion_p5.to_f + $participacion_p6.to_f + $participacion_p7.to_f)*100).round(3)
end

def puntaje_total_obtenido
  return (puntaje_total_obtenido_eje1.to_f + puntaje_total_obtenido_eje2.to_f + puntaje_total_obtenido_eje3.to_f + puntaje_total_obtenido_eje4.to_f + puntaje_total_obtenido_eje5.to_f).to_f.round(3)
end



def puntaje_total_obtenido_eje1(tipo=nil, avance=nil)
  if tipo=="proyecto"
    @vpuntaje_eje1_p1 = puntaje_eje1_p1("proyecto", avance) ? puntaje_eje1_p1("proyecto", avance) : 0
    @vpuntaje_eje1_p2 = puntaje_eje1_p2("proyecto", avance) ? puntaje_eje1_p2("proyecto", avance) : 0
    @vpuntaje_eje1_p3 = puntaje_eje1_p3("proyecto", avance) ? puntaje_eje1_p3("proyecto", avance) : 0
    @vpuntaje_eje1_p4 = puntaje_eje1_p4("proyecto", avance) ? puntaje_eje1_p4("proyecto", avance) : 0
    @vpuntaje_eje1_p5 = puntaje_eje1_p5("proyecto", avance) ? puntaje_eje1_p5("proyecto", avance) : 0
  else
    @vpuntaje_eje1_p1 = puntaje_eje1_p1 ? puntaje_eje1_p1 : 0
    @vpuntaje_eje1_p2 = puntaje_eje1_p2 ? puntaje_eje1_p2 : 0
    @vpuntaje_eje1_p3 = puntaje_eje1_p3 ? puntaje_eje1_p3 : 0
    @vpuntaje_eje1_p4 = puntaje_eje1_p4 ? puntaje_eje1_p4 : 0
    @vpuntaje_eje1_p5 = puntaje_eje1_p5 ? puntaje_eje1_p5 : 0
  end



  return (@vpuntaje_eje1_p1.to_f + @vpuntaje_eje1_p2.to_f + @vpuntaje_eje1_p3.to_f + @vpuntaje_eje1_p4.to_f + @vpuntaje_eje1_p5.to_f).to_f.round(3)
end

def puntaje_total_obtenido_eje2
  @vpuntaje_eje2_p2 = puntaje_eje2_p2 ? puntaje_eje2_p2 : 0
  @vpuntaje_eje2_p3 = puntaje_eje2_p3 ? puntaje_eje2_p3 : 0
  @vpuntaje_eje2_p5 = puntaje_eje2_p5 ? puntaje_eje2_p5 : 0
  return (@vpuntaje_eje2_p2.to_f + @vpuntaje_eje2_p3.to_f + @vpuntaje_eje2_p5.to_f).to_f.round(3)
end

def puntaje_total_obtenido_eje3
  @vpuntaje_eje3_p1 = puntaje_eje3_p1 ? puntaje_eje3_p1 : 0
  @vpuntaje_eje3_p3 = puntaje_eje3_p3 ? puntaje_eje3_p3 : 0
  @vpuntaje_eje3_p5 = puntaje_eje3_p5 ? puntaje_eje3_p5 : 0
  @vpuntaje_eje3_p7 = puntaje_eje3_p7 ? puntaje_eje3_p7 : 0
  @vpuntaje_eje3_p8 = puntaje_eje3_p8 ? puntaje_eje3_p8 : 0
  @vpuntaje_eje3_p9 = puntaje_eje3_p9 ? puntaje_eje3_p9 : 0
 return (@vpuntaje_eje3_p1.to_f + @vpuntaje_eje3_p3.to_f + @vpuntaje_eje3_p5.to_f + @vpuntaje_eje3_p7.to_f + @vpuntaje_eje3_p8.to_f + @vpuntaje_eje3_p9.to_f).to_f.round(3)
end

def puntaje_total_obtenido_eje4
  @vpuntaje_eje4_p2 = (puntaje_eje4_p2) ? (puntaje_eje4_p2) : 0
  @vpuntaje_eje4_p3 = (puntaje_eje4_p3) ? (puntaje_eje4_p3) : 0
  @vpuntaje_eje4_p4 = (puntaje_eje4_p4) ? (puntaje_eje4_p4) : 0
  @vpuntaje_eje4_p5 = (puntaje_eje4_p5) ? (puntaje_eje4_p5) : 0
  @vpuntaje_eje4_p6 = (puntaje_eje4_p6) ? (puntaje_eje4_p6) : 0
  @vpuntaje_eje4_p7 = (puntaje_eje4_p7) ? (puntaje_eje4_p7) : 0
  @vpuntaje_eje4_p8 = (puntaje_eje4_p8) ? (puntaje_eje4_p8) : 0
  return (@vpuntaje_eje4_p2 + @vpuntaje_eje4_p3 + @vpuntaje_eje4_p4 + @vpuntaje_eje4_p5 + @vpuntaje_eje4_p6 + @vpuntaje_eje4_p7 + @vpuntaje_eje4_p8).to_f.round(3)
end

def puntaje_total_obtenido_eje5
  @vpuntaje_eje5_p2 = (puntaje_eje5_p2) ? (puntaje_eje5_p2) : 0
  @vpuntaje_eje5_p3 = (puntaje_eje5_p3) ? (puntaje_eje5_p3) : 0
  @vpuntaje_eje5_p4 = (puntaje_eje5_p4) ? (puntaje_eje5_p4) : 0
  @vpuntaje_eje5_p5 = (puntaje_eje5_p5) ? (puntaje_eje5_p5) : 0
  @vpuntaje_eje5_p6 = (puntaje_eje5_p6) ? (puntaje_eje5_p6) : 0
  @vpuntaje_eje5_p7 = (puntaje_eje5_p7) ? (puntaje_eje5_p7) : 0
  return (@vpuntaje_eje5_p2 + @vpuntaje_eje5_p3 + @vpuntaje_eje5_p4 + @vpuntaje_eje5_p5 + @vpuntaje_eje5_p6 + @vpuntaje_eje5_p7 ).to_f.round(3)
end


###--- TOTALES AVANCES ---
def puntaje_total_avance
  return 1.5625 * 5
end

def puntaje_obtenido_avance(avance, eje)
  total = 0.0
#  (1..5).each do |eje|
    (1..4).each do |actividad|
      total += puntaje_avance_eje(avance, eje, actividad)
    end
#  end

  return total
end

def puntaje_total_novidencias
#### Aqui hacemos una consulta para obtener el ppuntaje de las no evidencias
end

def clean_adjuntos(eje,diagnostico, numero_pregunta)
       puts("=> BUSCANDO ARCHIVOS")
       contador_archivos=0
       @adjuntos = Adjunto.find(:all, :conditions =>["eje_id =? AND diagnostico_id = ? AND numero_pregunta = ?", eje,diagnostico,numero_pregunta]).each do |a|
#       file_exists = File.exists?(a.full_path)
       deleted =  a.destroy 
       (deleted) ?  contador_archivos+=1 : nil
       end
      puts("=> ADJUNTOS BORRADOS: #{contador_archivos}")
   end





end

