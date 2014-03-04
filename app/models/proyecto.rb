class Proyecto < ActiveRecord::Base
  has_many :ejes
  belongs_to :diagnostico
end
