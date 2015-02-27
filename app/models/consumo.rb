class Consumo < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :frecuencia_afisica
  has_and_belongs_to_many :establecimientos, :join_table => 'consumos_establecimientos'
  has_and_belongs_to_many :preparacions, :join_table => 'consumos_preparacions'
  has_and_belongs_to_many :utensilios, :join_table => 'consumos_utensilios'
  has_and_belongs_to_many :higienes, :join_table => 'consumos_higienes'
  has_and_belongs_to_many :materials, :join_table => 'consumos_materials'
  has_and_belongs_to_many :bebidas, :join_table => 'consumos_bebidas'
  has_and_belongs_to_many :alimentos, :join_table => 'consumos_alimentos'
  has_and_belongs_to_many :botanas, :join_table => 'consumos_botanas'
  has_and_belongs_to_many :reposterias, :join_table => 'consumos_reposterias'

  validates_presence_of :evidencia_pregunta_2, :if => "self.capacitacion_alim_bebidas == 'SI'"
  validates_presence_of :evidencia_pregunta_3, :if => "self.conocen_lineamientos_grales == 'SI'"
  validates_presence_of :evidencia_pregunta_7, :if => :realiza_actividad_fisica!
  validates_presence_of :evidencia_pregunta_8, :if => :tiempo_actividad_fisica!

  def tiempo_actividad_fisica!
    (realiza_actividad_fisica! && self.minutos_activacion_fisica) ?   self.minutos_activacion_fisica > 0 : nil
  end

  def realiza_actividad_fisica!
    (self.frecuencia_afisica)? !self.frecuencia_afisica.clave.include?('NOSR') : nil
  end

  def evidencia_pregunta_2
    current_eje = 4
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_3
    current_eje = 4
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
    (contador > 0)?  true : false
  end

  def evidencia_pregunta_7
    current_eje = 4
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 7])
    (contador > 0)?  true : false
  end

   def evidencia_pregunta_8
    current_eje = 4
    contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 8])
    (contador > 0)?  true : false
  end
end
