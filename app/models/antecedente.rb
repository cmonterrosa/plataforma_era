class Antecedente < ActiveRecord::Base
 belongs_to :escuela
 belongs_to :ciclo
 belongs_to :estatu
 #establish_connection "era2014"
end
