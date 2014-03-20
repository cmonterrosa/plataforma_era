class Actividad < ActiveRecord::Base
  has_many :avances
  belongs_to :eje
end
