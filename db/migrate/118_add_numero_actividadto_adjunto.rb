class AddNumeroActividadtoAdjunto < ActiveRecord::Migration
  def self.up
    add_column :adjuntos, :numero_actividad, :integer
  end

  def self.down
    remove_column :adjuntos, :numero_actividad
  end
end
