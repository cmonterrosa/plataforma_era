class AlumnosCapacitado < ActiveRecord::Base
  belongs_to :dcapacitadora
  belongs_to :competencia
end
