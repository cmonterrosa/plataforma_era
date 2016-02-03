class Competencia < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :proyecto

  has_many :alumnos_capacitados
  has_many :docentes_capacitados
  has_many :alumnos_brigadas
  has_many :docentes_brigadas

  validates_presence_of :evidencia_pregunta_1, :if => :validate_docentes
  validates_presence_of :evidencia_pregunta_2, :if => "self.dctes_aplican_conocimto.to_i > 0"
  validates_presence_of :evidencia_pregunta_3, :if => "self.dctes_invol_act.to_i > 0"
  validates_presence_of :evidencia_pregunta_4, :if => "self.alumn_cap_dctes.to_i > 0"
  validates_presence_of :evidencia_pregunta_5, :if => :validate_alumnos
  validates_presence_of :evidencia_pregunta_6, :if => "self.alumnos_involucran_actividades > 0"

#  attr_accessible :num_avance

  def num_avance_attribute(value=nil)
#    write_attribute(:num_avance, value)
    self.write_attribute(:num_avance, value)
  end

  def num_avance=(value)
    raise "es privado"
  end

  def evidencia_pregunta_1
    current_eje = 1
    numero_pregunta=1
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 1
    numero_pregunta=2
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    current_eje = 1
    numero_pregunta=3
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_4
    current_eje = 1
    numero_pregunta=4
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_5
    current_eje = 1
    numero_pregunta=5
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_6
    current_eje = 1
    numero_pregunta=6
    if self.proyecto
      contador = 1 unless Competencia.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def validate_docentes
    self.dctes_cap_salud.to_i > 0 || self.dctes_cap_ma.to_i > 0 || self.dctes_cap_ambos.to_i > 0
  end

  def validate_alumnos
    self.alumn_cap_salud.to_i > 0 || self.alumn_cap_ma.to_i > 0 || self.alumn_cap_ambos.to_i > 0
  end

end
