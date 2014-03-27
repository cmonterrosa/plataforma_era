class Avance < ActiveRecord::Base
  belongs_to :actividad

#  validates_presence_of :evidencia_pregunta_1
#
#
#  def evidencia_preguntas
#    current_eje = 1
#    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
#    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
#    (contador > 0)?  true : false
#  end

end
