class EliminaOrganico < ActiveRecord::Base
  has_and_belongs_to_many :huellas, :join_table => 'huellas_elimina_organicos'
end
