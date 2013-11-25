class Consumo < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :enfermedads, :join_table => 'Consumos_Enfermedads'
  belongs_to :establecimiento
  belongs_to :cubierto
  belongs_to :plato
  belongs_to :vaso
#  belongs_to :utensilio
end
