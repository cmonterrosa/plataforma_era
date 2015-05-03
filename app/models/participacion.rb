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

   attr_accessible :num_avance

   def num_avance=(value)
      write_attribute(:num_avance, value)
   end

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
      current_eje = 5
      numero_pregunta=1
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_2
       current_eje = 5
      numero_pregunta=2
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_3
       current_eje = 5
      numero_pregunta=3
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_4
      current_eje = 5
      numero_pregunta=4
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_5
      current_eje = 5
      numero_pregunta=5
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end
    
    def evidencia_pregunta_6
      current_eje = 5
      numero_pregunta=6
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end

    def evidencia_pregunta_7
      current_eje = 5
      numero_pregunta=7
      if self.proyecto
        contador = 1 unless Participacion.find_by_proyecto_id(self.proyecto.id)
        contador ||= Adjunto.count(:id, :conditions => ["eje_id = ? AND proyecto_id = ? AND numero_pregunta = ? AND avance=?", current_eje, self.proyecto_id, numero_pregunta, self.num_avance]) if self.num_avance
        contador ||=0
      else
        contador = Adjunto.count(:id, :conditions => ["eje_id = ? AND diagnostico_id = ? AND numero_pregunta = ?", current_eje, self.diagnostico_id, numero_pregunta])
      end
      (contador > 0)?  true : false
    end
end
