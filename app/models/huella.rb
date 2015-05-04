class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :proyecto
  belongs_to :energia_electrica
  has_and_belongs_to_many :servicio_aguas, :join_table => 'huellas_servicio_aguas'
  has_and_belongs_to_many :inorganicos, :join_table => 'huellas_inorganicos'
  has_and_belongs_to_many :elimina_residuos, :join_table => 'huellas_elimina_residuos'

  validates_presence_of :evidencia_pregunta_1, :if => "self.capacitacion_ahorro_energia == 'SI'"
  validates_presence_of :evidencia_pregunta_2, :if => "self.consumo_anterior.to_i > 0 and self.consumo_actual.to_i > 0"
  validates_presence_of :evidencia_pregunta_7, :if => "self.sep_residuos_org_inorg == 'SI'"
  validates_presence_of :evidencia_pregunta_8, :if => "self.elabora_compostas == 'SI'"
  validates_presence_of :evidencia_pregunta_9, :if => :valida_inorganicos

#  attr_accessible :num_avance

   def num_avance_attribute(value=nil)
#    write_attribute(:num_avance, value)
    self.write_attribute(:num_avance, value)
  end
  
  def num_avance=(value)
    raise "es privado"
  end

  def evidencia_pregunta_1
    current_eje = 3
    numero_pregunta=1
    if self.proyecto
      contador = 1 unless Huella.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_2
    current_eje = 3
    numero_pregunta=2
    if self.proyecto
      contador = 1 unless Huella.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_7
    current_eje = 3
    numero_pregunta=7
    if self.proyecto
      contador = 1 unless Huella.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_8
    current_eje = 3
    numero_pregunta=8
    if self.proyecto
      contador = 1 unless Huella.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_9
    current_eje = 3
    numero_pregunta=9
    if self.proyecto
      contador = 1 unless Huella.find_by_proyecto_id(self.proyecto.id)
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def valida_inorganicos
    return true if self.proyecto
    self.inorganicos.each do |i|
      return false if i.clave == "NING"
    end
    return true
  end
end
