class Reporte < ActiveRecord::Base
  has_one :dcompetencia
  belongs_to :user
  belongs_to :escuela
  belongs_to :tipo_reporte
end
