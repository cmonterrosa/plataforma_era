class SectorSalud < ActiveRecord::Base
  has_and_belongs_to_many :entornos, :join_table => 'Entornos_Sector_Saluds'
end
