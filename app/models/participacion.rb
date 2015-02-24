class Participacion < ActiveRecord::Base
    belongs_to :diagnostico
    belongs_to :acomunitaria
    belongs_to :pcolectiva
    has_and_belongs_to_many :pescolars

#    validates_presence_of :evidencia_pregunta_1, :if => "self.num_padres_familia > 0"
#    validates_presence_of :evidencia_pregunta_2, :if => "self.capacitacion_salud_ma.to_i >0"
#    validates_presence_of :evidencia_pregunta_3, :if => "self.proy_escolares_ma.to_i > 0"
#    validates_presence_of :evidencia_pregunta_4, :if => "self.proy_escolares_salud.to_i > 0"
#    validates_presence_of :evidencia_pregunta_5, :if => "self.act_salud_ma.to_i > 0"
#    validates_presence_of :evidencia_pregunta_6, :if => "self.act_dep_gobierno.to_i > 0"


    def dcapacitadoras
      return CapacitacionPadre.find(:all, :conditions => ["participacion_id = ?", self.id])
    end

    def evidencia_pregunta_1
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
      #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_2
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_3
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_4
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 4])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_5
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 5])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end
    
    def evidencia_pregunta_6
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 6])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end
end
