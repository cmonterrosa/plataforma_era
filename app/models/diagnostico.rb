class Diagnostico < ActiveRecord::Base
   belongs_to :escuela
   has_one :competencia
   has_one :entorno
   has_one :consumo
   has_one :participacion
   has_one :huella
end
