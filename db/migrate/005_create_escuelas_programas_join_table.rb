class CreateEscuelasProgramasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :escuelas_programas, :id => false do |t|
      t.integer :escuela_id
      t.integer :programa_id
    end
  end

  def self.down
    drop_table :escuelas_programas
  end
end
