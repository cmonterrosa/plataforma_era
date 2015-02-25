class CreatePescolars < ActiveRecord::Migration
  def self.up
    create_table :pescolars do |t|
      t.integer :participacion_id
      t.string :nombre, :limit => 60
      t.string :descripcion, :limit => 150
      t.string :materia, :limit => 150
      t.string :dependencia_secretaria_apoya, :limit => 100
      t.timestamps
    end

    add_index :pescolars, [:participacion_id], :name => 'pescolar_participacion'
    add_index :pescolars, [:participacion_id, :materia], :name => 'pescolar_materia_participacion'

  end

  def self.down
    drop_table :pescolars
  end
end
