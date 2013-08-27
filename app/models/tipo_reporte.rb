class TipoReporte < ActiveRecord::Base
  has_many :reportes
  belongs_to :escuela
end
