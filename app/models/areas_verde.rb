class AreasVerde < ActiveRecord::Base
  has_and_belongs_to_many :entornos, :join_table => 'Entornos_Areas_Verdes'
end
