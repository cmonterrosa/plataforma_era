class Entorno < ActiveRecord::Base
  belongs_to :diagnostico

  before_save :check

  def check
    self.areas_verdes_esc_desc = "" if self.areas_verdes_esc == "NO"
    self.cuidado_preserv_reforest_desc = "" if self.cuidado_preserv_reforest == "NO"
    self.adopta_areas_verdes_desc = "" if self.adopta_areas_verdes == "NO"
    self.promueve_cuidado_salud_desc = "" if self.promueve_cuidado_salud == "NO"
    self.tiempo_activacion_fisica = "" if self.promueve_activacion_fisica == "NO"
  end
  
end
