class Consumo < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :frecuencia_afisica
  has_and_belongs_to_many :establecimientos, :join_table => 'consumos_establecimientos'
  has_and_belongs_to_many :bebidas, :join_table => 'consumos_bebidas'
  has_and_belongs_to_many :alimentos, :join_table => 'consumos_alimentos'
  has_and_belongs_to_many :botanas, :join_table => 'consumos_botanas'
  has_and_belongs_to_many :reposterias, :join_table => 'consumos_reposterias'
  has_and_belongs_to_many :utensilios, :join_table => 'consumos_utensilios'
end
