class CreateCompetenciasTambientalsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_tambientals, :id => false do |t|
      t.integer :competencia_id
      t.integer :tambiental_id
    end
  end

  def self.down
    drop_table :competencias_tambientals
  end
end
