class Consumo < ActiveRecord::Base
  belongs_to :diagnostico

  before_save :check

  def check
    self.alim_bajos_sodio_grasa_desc = "" if self.alim_bajos_sodio_grasa == "NO"
  end
end
