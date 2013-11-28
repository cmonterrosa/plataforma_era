class Competencia < ActiveRecord::Base
  belongs_to :diagnostico
  has_and_belongs_to_many :cmambientes, :join_table => 'competencias_cmambientes'
  has_and_belongs_to_many :csaluds, :join_table => 'competencias_csaluds'
  has_and_belongs_to_many :pedagogicas, :join_table => 'competencias_pedagogicas'
  has_and_belongs_to_many :tambientals, :join_table => 'competencias_tambientals'
  has_and_belongs_to_many :cactividads, :join_table => 'competencias_cactividads'
  has_and_belongs_to_many :saludmas, :join_table => 'competencias_saludmas'
end
