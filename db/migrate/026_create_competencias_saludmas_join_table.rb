class CreateCompetenciasSaludmasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_saludmas, :id => false do |t|
      t.integer :competencia_id
      t.integer :saludma_id
    end
  end

  def self.down
    drop_table :competencias_saludmas
  end
end
