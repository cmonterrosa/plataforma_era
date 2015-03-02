class EscuelasEspacio < ActiveRecord::Base
  belongs_to :entorno
  belongs_to :espacio
end
