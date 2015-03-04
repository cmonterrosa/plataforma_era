class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :acciones, :join_table => 'entornos_acciones'
  has_many :escuelas_espacios

  validates_presence_of :evidencia_pregunta_1, :if => "self.superficie_terreno_escuela.to_i > 0"
  validates_presence_of :evidencia_pregunta_2, :if => "!self.escuelas_espacios.empty?"
  validates_presence_of :evidencia_pregunta_3, :if => "self.escuela_reforesta == 'SI'"
  validates_presence_of :evidencia_pregunta_5, :if => :valida_acciones

  def evidencia_pregunta_1
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
    #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_5
    current_eje = 2
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 5])
    #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def valida_acciones
    self.acciones.each do |a|
      if a.clave == 'NING'
        return false
      end
    end
    return true
  end
  
  def valida_espacios
    return self.escuelas_espacios ? true : false
  end

end
