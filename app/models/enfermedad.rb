class Enfermedad < ActiveRecord::Base
  has_and_belongs_to_many :consumos, :join_table => 'Consumos_Enfermedads'
end
