class Participacion < ActiveRecord::Base
    belongs_to :diagnostico
    belongs_to :proyecto
    belongs_to :acomunitaria
    belongs_to :pcolectiva
    has_many :pescolars
    has_many :capacitacion_padres

    ##### Validaciones ####

    validates_presence_of :evidencia_pregunta_1, :if => "self.num_padres_familia.to_i  > 0"
    validates_presence_of :evidencia_pregunta_2, :if => "self.capacitacion_salud_ma.to_i >0"
    validates_presence_of :evidencia_pregunta_3, :if =>  "(self.capacitacion_salud.to_i + self.capacitacion_medioambiente.to_i) > 0"
    validates_presence_of :evidencia_pregunta_4, :if =>  :instituciones_capacitado?
    validates_presence_of :evidencia_pregunta_5, :if =>  :tiene_proyectos_ambiente?
    validates_presence_of :evidencia_pregunta_6, :if =>  :tiene_proyectos_salud?
    validates_presence_of :evidencia_pregunta_7, :if =>  :tiene_proyectos_dependencias?


   def instituciones_capacitado?
     (self.capacitacion_padres.empty?)? nil : true
   end

   def tiene_proyectos_ambiente?
      contador = Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia= ?", self.id, 'MEDIOAMBIENTE'])
     (contador > 0)?  true : false
    end

   def tiene_proyectos_salud?
      contador = Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia= ?", self.id, 'SALUD'])
     (contador > 0)?  true : false
    end


    def tiene_proyectos_dependencias?
      contador = Pescolar.count(:id, :conditions => ["participacion_id = ? AND materia= ?", self.id, 'DEPENDENCIAS'])
     (contador > 0)?  true : false
    end



    def dcapacitadoras
      capacitaciones = CapacitacionPadre.find(:all, :conditions => ["participacion_id = ?", self.id])
      (capacitaciones)? Dcapacitadora.find(capacitaciones.map{ |i|i.dcapacitadora_id  }) : nil
    end

    def evidencia_pregunta_1
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 1])
      #self.errors.add(:pregunta_3, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_2
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 2])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_3
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 3])
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_4
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 4])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_5
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 5])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end
    
    def evidencia_pregunta_6
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 6])
      #self.errors.add(:pregunta_4, "=> Requiere evidencia") if contador < 1
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_7
      return true if self.proyecto
      current_eje = 5
      contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, 7])
      (contador > 0)?  true : false
    end
end
