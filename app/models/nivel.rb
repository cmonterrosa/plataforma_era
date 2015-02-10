class Nivel < ActiveRecord::Base
  has_many :escuelas
  has_many :users
end
