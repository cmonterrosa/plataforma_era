class DocentesBrigada < ActiveRecord::Base
  belongs_to :brigada
  belongs_to :competencia
end
