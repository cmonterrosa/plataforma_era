class CapacitacionPadre < ActiveRecord::Base
  belongs_to :dcapacitadora
  belongs_to :participacion
end
