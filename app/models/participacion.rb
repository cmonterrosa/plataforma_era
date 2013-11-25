class Participacion < ActiveRecord::Base
    belongs_to :diagnostico
    belongs_to :acomunitaria
    belongs_to :pcolectiva
end
