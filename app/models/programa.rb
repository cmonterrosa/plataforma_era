class Programa < ActiveRecord::Base
  has_and_belongs_to_many :escuelas, :join_table => 'escuelas_programas'
end
