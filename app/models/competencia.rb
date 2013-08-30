class Competencia < ActiveRecord::Base
  belongs_to :diagnostico

  before_save :check

  def check
    self.doc_capacitan_salud_desc = "" if self.doc_capacitan_salud == "NO"
    self.doc_capacitan_ma_desc = "" if self.doc_capacitan_ma == "NO"
    self.aplica_conocimientos_desc = "" if self.aplica_conocimientos == "NO"
  end

end
