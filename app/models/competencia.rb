class Competencia < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :proyecto

  has_many :alumnos_capacitados
  has_many :docentes_capacitados

  validates_presence_of :evidencia_pregunta_1, :if => :validate_docentes
  validates_presence_of :evidencia_pregunta_2, :if => "self.dctes_aplican_conocimto.to_i > 0"
  validates_presence_of :evidencia_pregunta_3, :if => "self.dctes_invol_act.to_i > 0"
  validates_presence_of :evidencia_pregunta_4, :if => "self.alumn_cap_dctes.to_i > 0"
  validates_presence_of :evidencia_pregunta_5, :if => :validate_alumnos

  attr_accessible :num_avance

   def num_avance=(value)
      write_attribute(:num_avance, value)
   end

  def evidencia_pregunta_1
    current_eje = 1
    numero_pregunta=1
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    return true if self.proyecto
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    return true if self.proyecto
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_4
    return true if self.proyecto
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 4])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_5
    return true if self.proyecto
    current_eje = 1
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 5])
    #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
    (contador > 0)?  true : false
  end

  def validate_docentes
    self.dctes_cap_salud.to_i > 0 || self.dctes_cap_ma.to_i > 0 || self.dctes_cap_ambos.to_i > 0
  end

  def validate_alumnos
    self.alumn_cap_salud.to_i > 0 || self.alumn_cap_ma.to_i > 0 || self.alumn_cap_ambos.to_i > 0
  end
end
