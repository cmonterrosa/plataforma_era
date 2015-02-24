class CreateCapacitacionPadres < ActiveRecord::Migration
  def self.up
    ### Pregunta 4 Eje 5 ###
    create_table :capacitacion_padres do |t|
      t.integer :participacion_id
      t.integer :dcapacitadora_id
      t.integer :numero_capacitaciones
      t.timestamps
    end

    add_index :capacitacion_padres, [:participacion_id, :dcapacitadora_id], :name => 'capacitaciones_padres'

  end

  def self.down
    drop_table :capacitacion_padres
  end
end
