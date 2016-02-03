module Functions

  def selected(relacion)
    if relacion
      @selected=relacion.clave
    else
      @selected=""
    end
    return @selected
  end

  def multiple_selected(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.clave}
    end
    return @selected
  end

  def multiple_selected_id(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.id}
    end
    return @selected
  end

  def multiple_selected_espacios(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.espacio_id}
    end
    return @selected
  end

  def multiple_selected_dcapacitadora(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.dcapacitadora_id}
    end
    return @selected
  end

  def multiple_selected_brigada(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.brigada_id}
    end
    return @selected
  end

  # Puntajes de preguntas del Eje 1 Competencias
  $competencia_p1 = 0.02941
  $competencia_p2 = 0.02941
  $competencia_p3 = 0.02941
  $competencia_p4 = 0.02941
  $competencia_p5 = 0.02941
  $competencia_p6 = 0.02941

  # Puntajes de preguntas del Eje 2 Entornos
  $entorno_p2 = 0.03125
  $entorno_p3 = 0.03125
  $entorno_p5 = 0.03125

  # Puntajes de preguntas del Eje 3 Huella Ecológica
  $huella_p1 = 0.03125
  $huella_p3 = 0.03125
  $huella_p5 = 0.03125
  $huella_p7 = 0.03125
  $huella_p8 = 0.03125
  $huella_p9 = 0.03125

  def ptos_inorganicos(porcentaje)
    case porcentaje
    when 0
      return 0
    when 1
      return 0.645
    when 2
      return 1.25
    when 3
      return 1.875
    when 4
      return 2.5
    when 5
      return 3.125
    end
  end

  $consumo_p2 = 0.03125
  $consumo_p3 = 0.03125
  $consumo_p4 = 0.03125
  $consumo_p5 = 0.03125
  $consumo_p6 = 0.03125
  $consumo_p7 = 0.03125

  def ptos_afisica(clave)
    case clave
    when 'NOSR'
      return 0
    when '01DS'
      return 0.625
    when '02DS'
      return 1.25
    when '03DS'
      return 1.875
    when '04DS'
      return 2.5
    when '05DS'
      return 3.125
    end
  end

  $consumo_p8 = 0.03125

  def ptos_minutos(valor)
    case valor
    when 10
      return 0.625
    when 15
      return 1.25
    when 20
      return 1.875
    when 25
      return 2.5
    when 30
      return 3.125
    end
  end

  $participacion_p1 = 0 #Agregado porque requiere evidencia
  $participacion_p2 = 0.03125
  $participacion_p3 = 0.03125
  $participacion_p4 = 0.03125
  $participacion_p5 = 0.03125
  $participacion_p6 = 0.03125
  $participacion_p7 = 0.03125
  

  def ptos_participacion(valor)
    case valor
    when 0
      return 0
    when 1
      return 1.5625
    when 2
      return 3.125
    end
  end

  def ptos_capacitaciones(valor)
    case valor
    when -1..0
      return 0
    when 1..15
      return 1.5625
    end
  end

  def ptos_proyectos(valor)
    case valor
    when -1..0
      return 0
    when 1..15
      return 3.125
    end
  end


  $avance_actividad = 0.390625

  def evidencia_valida?(eje=nil, num_pregunta=nil, diagnostico=nil, proyecto=nil, avance=nil)
    e_proyecto = Proyecto.find(proyecto) if proyecto
    e_diagnostico = Diagnostico.find(diagnostico) if diagnostico
    contador=0
    contador = Adjunto.count(:id, :conditions => ["diagnostico_id = ? AND eje_id = ? AND numero_pregunta = ? AND validado = ?",  diagnostico.id, eje, num_pregunta, true], :order => "eje_id") if e_diagnostico
    contador = Adjunto.count(:id, :conditions => ["proyecto_id = ? AND eje_id = ? AND numero_pregunta = ? AND avance= ? and validado = ?",  proyecto.id, eje, num_pregunta, avance, true], :order => "eje_id") if e_proyecto && avance
    (contador > 0)? true : false
  end
end