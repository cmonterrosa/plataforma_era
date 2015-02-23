class Ajuste2015Eje5 < ActiveRecord::Migration
  def self.up

    # Pregunta 3
    remove_column :participacions, :capacitacion_salud_ma
    add_column:participacions, :capacitacion_salud, :integer
    add_column:participacions, :capacitacion_medioambiente, :integer
  end

  def self.down
  end
end
