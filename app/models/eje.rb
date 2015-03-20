class Eje < ActiveRecord::Base
  belongs_to :proyecto
  belongs_to :catalogo_eje
  has_many :actividads
#  belongs_to :indicadore
#  belongs_to :lineas_accion
end
