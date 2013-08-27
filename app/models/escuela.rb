class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
  belongs_to :categoria_escuela
  has_many :tipo_reportes
end
