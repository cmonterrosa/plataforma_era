class CatalogoEje < ActiveRecord::Base
  has_many :ejes
  has_many :lineas_accions
  has_many :indicadores


  def completo
    "#{clave} - #{descripcion}"
  end
end
