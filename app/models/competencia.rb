class Competencia < ActiveRecord::Base
  belongs_to :diagnostico

#  before_save :check
#  before_save :change_to_upcase

#  def check
#    self.doc_capacitan_salud_desc = "" if self.doc_capacitan_salud == "NO"
#    self.doc_capacitan_salud_desc.strip!
#    self.doc_capacitan_ma_desc = "" if self.doc_capacitan_ma == "NO"
#    self.aplica_conocimientos_desc = "" if self.aplica_conocimientos == "NO"
#    self.esc_desarrolla_proy_desc = "" if self.esc_desarrolla_proy == "NO"
#    self.alu_involucran_proy_desc = "" if self.alu_involucran_proy == "NO"
#    self.alu_capacitan_salud_ma_desc = "" if self.alu_capacitan_salud_ma == "NO"
#  end
end
