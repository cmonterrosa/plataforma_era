class Entorno < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :acciones, :join_table => 'acciones_entornos'
end
