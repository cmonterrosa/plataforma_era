class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :areas_verdes, :join_table => 'entornos_areas_verdes'
  has_and_belongs_to_many :actividads, :join_table => 'entornos_actividads'
  has_and_belongs_to_many :cuidado_saluds, :join_table => 'entornos_cuidado_saluds'
  has_and_belongs_to_many :sector_saluds, :join_table => 'entornos_sector_saluds'
  
end
