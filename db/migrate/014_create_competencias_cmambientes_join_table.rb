class CreateCompetenciasCmambientesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_cmambientes, :id => false do |t|
      t.integer :competencia_id
      t.integer :cmambiente_id
    end
  end

  def self.down
    drop_table :competencias_cmambientes
  end
end
