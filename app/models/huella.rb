class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :servicio_agua
  belongs_to :energia_electrica
  has_and_belongs_to_many :inorganicos, :join_table => 'huellas_inorganicos'
  has_and_belongs_to_many :elimina_organicos, :join_table => 'huellas_elimina_organicos'
  has_and_belongs_to_many :elimina_inorganicos, :join_table => 'huellas_elimina_inorganicos'
end
