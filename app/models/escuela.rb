class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
  has_one :diagnostico
  belongs_to :categoria_escuela
end
