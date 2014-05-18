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

  $competencia_p1 = 0.03225
  $competencia_p2 = 0.03225
  $competencia_p3 = 0.03225
  $competencia_p4 = 0.03225
  $competencia_p5 = 0.03225

  $entorno_p2 = 0.03225
  $entorno_p6 = 0.03225

  def ptos_superficie(porcentaje)
    case porcentaje
    when 0
      return 0
    when 1
      return 0.1288
    when 2
      return 0.2576
    when 3
      return 0.3864
    when 4
      return 0.5152
    when 5
      return 0.644
    when 6
      return 0.7728
    when 7
      return 0.9016
    when 8
      return 1.0304
    when 9
      return 1.1592
    when 10
      return 1.288
    when 11
      return 1.4168
    when 12
      return 1.5456
    when 13
      return 1.6744
    when 14
      return 1.8032
    when 15
      return 1.932
    when 16
      return 2.0608
    when 17
      return 2.1896
    when 18
      return 2.3184
    when 19
      return 2.4472
    when 20
      return 2.576
    when 21
      return 2.7048
    when 22
      return 2.8336
    when 23
      return 2.9624
    when 24
      return 3.0912
    when 25
      return 3.225
    end
  end

  $huella_p1 = 0.03225
  $huella_p2 = 0.03225
  $huella_p3 = 0.03225
  $huella_p4 = 0.03225
  $huella_p5 = 0.03225
  $huella_p6 = 0.03225
  $huella_p7 = 0.03225
  $huella_p8 = 0.03225
  $huella_p9 = 0.03225

  def ptos_inorganicos(porcentaje)
    case porcentaje
    when 0
      return 0
    when 1
      return 0.645
    when 2
      return 1.29
    when 3
      return 1.935
    when 4
      return 2.58
    when 5
      return 3.225
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

  $participacion_p2 = 0.03125
  $participacion_p3 = 0.03125
  $participacion_p4 = 0.03125
  $participacion_p5 = 0.03125

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

end