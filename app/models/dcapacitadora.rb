class Dcapacitadora < ActiveRecord::Base
  has_many :alumnos_capacitados
  has_many :docentes_capacitados
end
