class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :proyecto
  has_and_belongs_to_many :acciones, :join_table => 'entornos_acciones'
  has_many :escuelas_espacios

  validates_presence_of :evidencia_pregunta_1, :if => "self.superficie_terreno_escuela_av.to_f > 0"
  validates_presence_of :evidencia_pregunta_2, :if => "!self.escuelas_espacios.empty?"
  validates_presence_of :evidencia_pregunta_3, :if => "self.escuela_reforesta == 'SI'"
  validates_presence_of :evidencia_pregunta_5, :if => :valida_acciones

#  attr_accessible :num_avance

   def num_avance_attribute(value=nil)
#    write_attribute(:num_avance, value)
    self.write_attribute(:num_avance, value)
  end

  def num_avance=(value)
    raise "es privado"
  end

  def evidencia_pregunta_1
    current_eje = 2
    numero_pregunta=1
    if self.proyecto
      contador = 1 unless Entorno.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  ## Modificada ###
  def evidencia_pregunta_2
    current_eje = 2
    numero_pregunta=2
    if self.proyecto
      contador = 1 unless Entorno.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    current_eje = 2
    numero_pregunta=3
    if self.proyecto
      contador = 1 unless Entorno.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_5
    current_eje = 2
    numero_pregunta=5
    if self.proyecto
      contador = 1 unless Entorno.find_by_proyecto_id(self.proyecto.id)
      contador ||= 1 if self.num_avance == 0
      contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
      contador ||=0
    else
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
    end
    (contador > 0)?  true : false
  end

  def valida_acciones
    self.acciones.each do |a|
      return false if a.clave == 'NING'
    end
    return true
  end
  
  def valida_espacios
    return self.escuelas_espacios ? true : false
  end

end
