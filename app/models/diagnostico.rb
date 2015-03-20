class Diagnostico < ActiveRecord::Base
   belongs_to :escuela
   has_one :competencia
   has_one :entorno
   has_one :consumo
   has_one :participacion
   has_one :huella
   has_many :adjuntos
   has_one :proyecto
   has_many :evaluacions

   def folio
     "#{Time.now.year}#{self.id.to_s.rjust(5, '0')}"
   end

end
