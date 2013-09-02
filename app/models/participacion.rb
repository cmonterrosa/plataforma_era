class Participacion < ActiveRecord::Base
    belongs_to :diagnostico

  before_save :check

  def check
    self.apoyo_proy_product_desc = "" if self.apoyo_proy_product == "NO"
    self.familia_involucran_actividades_desc = "" if self.familia_involucran_actividades == "NO"
    self.esc_participa_proy_desc = "" if self.esc_participa_proy == "NO"
    self.esc_capacita_salud_ma_desc = "" if self.esc_capacita_salud_ma == "NO"
    self.padres_participan_proy_desc = "" if self.padres_participan_proy == "NO"
  end
end
