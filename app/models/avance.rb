class Avance < ActiveRecord::Base
  belongs_to :actividad

  validates_presence_of :evidencia_preguntas


  def evidencia_preguntas
    avance = self.numero
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND avance = ? AND proyecto_id = ?", self.actividad.eje.id, avance, self.actividad.eje.proyecto.id])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
    a = 0
  end

end
