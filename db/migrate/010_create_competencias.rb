class CreateCompetencias < ActiveRecord::Migration
  def self.up
    create_table :competencias do |t|
      t.integer :docentes_capacitados_sma
      t.integer :docentes_aplican_conocimientos
      t.integer :docentes_involucran_actividades
      t.integer :alumnos_capacitados_docentes
      t.integer :alumnos_capacitados_instituciones
      t.timestamps
      t.integer :diagnostico_id
    end

    add_index :competencias, :diagnostico_id, :name => "diagnostico"
    
  end

  def self.down
    drop_table :competencias
  end
end
