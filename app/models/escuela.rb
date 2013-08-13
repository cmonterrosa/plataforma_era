class Escuela < ActiveRecord::Base
  has_one :user
  has_one :proyecto
end
