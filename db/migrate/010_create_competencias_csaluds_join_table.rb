class CreateCompetenciasCsaludsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :competencias_csaluds, :id => false do |t|
      t.integer :competencia_id
      t.integer :csalud_id
    end
  end

  def self.down
    drop_table :competencias_csaluds
  end
end
