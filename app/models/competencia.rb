class Competencia < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :cmambientes, :join_table => 'Competencias_Cmambientes'
  has_and_belongs_to_many :csaluds, :join_table => 'Competencias_Csaluds'
  has_and_belongs_to_many :pedagogicas, :join_table => 'Competencias_Pedagogicas'
  has_and_belongs_to_many :tambientals, :join_table => 'Competencias_Tambientals'
  has_and_belongs_to_many :cactividads, :join_table => 'Competencias_Cactividads'
  has_and_belongs_to_many :saludmas, :join_table => 'Competencias_Saludmas'
  belongs_to :capacitan_salud
  belongs_to :capacitan_mambiente
  belongs_to :aplica_conocimiento
  belongs_to :participa_tambiental
  belongs_to :involucran_cactividad
  belongs_to :capacitan_saludma
end
