class Huella < ActiveRecord::Base
  belongs_to :diagnostico
  belongs_to :tipo_agua
  belongs_to :potabilidad_agua

  before_save :check

  def check
#    self.doc_capacitan_salud_desc = "" if self.doc_capacitan_salud == "NO"
  end
end
