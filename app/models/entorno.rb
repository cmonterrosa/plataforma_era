class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :acciones, :join_table => 'entornos_acciones'

  validates_presence_of :evidencia_pregunta_3, :if => "self.jardines_verticales == 'SI'"
  validates_presence_of :evidencia_pregunta_4, :if => "self.jardines_hidroponicos == 'SI'"

  def evidencia_pregunta_3
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_4
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 4])
    #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end



end
