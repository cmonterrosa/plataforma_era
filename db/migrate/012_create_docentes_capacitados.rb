class CreateDocentesCapacitados < ActiveRecord::Migration
  def self.up
    create_table :docentes_capacitados do |t|
      t.integer :numero
      t.string  :descripcion_dep
      t.integer :dcapacitadora_id
      t.integer :competencia_id
    end
  end

  def self.down
    drop_table :docentes_capacitados
  end
end