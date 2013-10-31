class CreateCompetenciasCactividadsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_cactividads, :id => false do |t|
      t.integer :competencia_id
      t.integer :cactividad_id
    end
  end

  def self.down
    drop_table :competencias_cactividads
  end
end
