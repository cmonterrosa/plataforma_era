class Proyecto < ActiveRecord::Base
  has_many :ejes
  has_many :adjuntos
  belongs_to :diagnostico
  has_many :evaluacions
end
