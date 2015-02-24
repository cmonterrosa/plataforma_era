class CreatePescolars < ActiveRecord::Migration
  def self.up
    create_table :pescolars do |t|
      t.string :nombre, :limit => 60
      t.string :descripcion, :limit => 150
      t.string :materia, :limit => 150
      t.string :dependencia_secretaria_apoya, :limit => 100
      t.timestamps
    end
  end

  def self.down
    drop_table :pescolars
  end
end
