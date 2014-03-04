class LineasAccion < ActiveRecord::Base
  has_many :ejes
  belongs_to :catalogo_eje
end
