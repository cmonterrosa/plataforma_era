class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :areas_verdes, :join_table => 'Entornos_Areas_Verdes'
  has_and_belongs_to_many :actividads, :join_table => 'Entornos_Actividads'
  has_and_belongs_to_many :cuidado_saluds, :join_table => 'Entornos_Cuidado_Saluds'
  has_and_belongs_to_many :sector_saluds, :join_table => 'Entornos_Sector_Saluds'
  
end
