class Diagnostico < ActiveRecord::Base
   belongs_to :escuela
   has_one :competencia
end
