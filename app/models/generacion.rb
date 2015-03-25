class Generacion < ActiveRecord::Base
  belongs_to :ciclo
  has_and_belongs_to_many :escuelas, :join_table => 'escuelas_generacions'
end
