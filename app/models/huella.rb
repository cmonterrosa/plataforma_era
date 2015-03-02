class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :energia_electrica
  has_and_belongs_to_many :servicio_aguas, :join_table => 'huellas_servicio_aguas'
  has_and_belongs_to_many :inorganicos, :join_table => 'huellas_inorganicos'
  has_and_belongs_to_many :elimina_residuos, :join_table => 'huellas_elimina_residuos'

  validates_presence_of :evidencia_pregunta_1, :if => "self.capacitacion_ahorro_energia == 'SI'"
  validates_presence_of :evidencia_pregunta_2, :if => "self.consumo_anterior.to_i > 0 and self.consumo_actual.to_i > 0"
  validates_presence_of :evidencia_pregunta_7, :if => "self.sep_residuos_org_inorg == 'SI'"
  validates_presence_of :evidencia_pregunta_8, :if => "self.elabora_compostas == 'SI'"
  validates_presence_of :evidencia_pregunta_9, :if => "self.inorganicos"
  

  def evidencia_pregunta_1
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador.to_i > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador.to_i > 0)?  true : false
  end

  def evidencia_pregunta_7
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 7])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador.to_i > 0)?  true : false
  end

  def evidencia_pregunta_8
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 8])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador.to_i > 0)?  true : false
  end

  def evidencia_pregunta_9
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 9])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador.to_i > 0)?  true : false
  end
end
