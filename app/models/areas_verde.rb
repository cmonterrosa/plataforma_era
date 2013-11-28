class AreasVerde < ActiveRecord::Base
  has_and_belongs_to_many :entornos, :join_table => 'entornos_areas_verdes'
end
