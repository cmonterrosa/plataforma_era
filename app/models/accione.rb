class Accione < ActiveRecord::Base
  has_and_belongs_to_many :entornos, :join_table => 'entornos_acciones'
end
