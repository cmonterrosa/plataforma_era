class CreateCompetenciasPedagogicasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_pedagogicas, :id => false do |t|
      t.integer :competencia_id
      t.integer :pedagogica_id
    end
  end

  def self.down
    drop_table :competencias_pedagogicas
  end
end
