class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :tipo_agua
  belongs_to :potabilidad_agua
end
