class Competencia < ActiveRecord::Base
  belongs_to :diagnostico

  validates_presence_of :evidencia_pregunta_1, :if => "self.docentes_capacitados_sma > 0"
  validates_presence_of :evidencia_pregunta_2, :if => "self.docentes_aplican_conocimientos > 0"
  validates_presence_of :evidencia_pregunta_3, :if => "self.docentes_involucran_actividades > 0"
  validates_presence_of :evidencia_pregunta_4, :if => "self.alumnos_capacitados_docentes > 0"
  validates_presence_of :evidencia_pregunta_5, :if => "self.alumnos_capacitados_instituciones > 0"


  def evidencia_pregunta_1
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_4
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 4])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_5
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 5])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end
end
