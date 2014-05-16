class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :servicio_agua
  belongs_to :energia_electrica
  has_and_belongs_to_many :inorganicos, :join_table => 'huellas_inorganicos'
  has_and_belongs_to_many :elimina_residuos, :join_table => 'huellas_elimina_residuos'

  validates_presence_of :evidencia_pregunta_1, :if => "self.capacitacion_ahorro_energia > 0"
  validates_presence_of :evidencia_pregunta_2, :if => "self.consumo_anterior > 0 and self.consumo_actual > 0"
  

  def evidencia_pregunta_1
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 3
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end
end
