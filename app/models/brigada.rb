class Brigada < ActiveRecord::Base
  has_many :alumnos_brigadas
  has_many :docentes_brigadas
end
