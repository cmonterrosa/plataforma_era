class Huella < ActiveRecord::Base
  belongs_to :diagnostico

  before_save :check

  def check
#    self.doc_capacitan_salud_desc = "" if self.doc_capacitan_salud == "NO"
  end
end
