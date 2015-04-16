class Proyecto < ActiveRecord::Base
  has_one :competencia
  has_one :entorno
  has_one :huella
  has_many :ejes
  has_many :adjuntos
  belongs_to :diagnostico
  has_many :evaluacions
end
