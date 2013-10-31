class Pedagogica < ActiveRecord::Base
  has_and_belongs_to_many :competencias, :join_table => 'Competencias_Pedagogicas'
end
