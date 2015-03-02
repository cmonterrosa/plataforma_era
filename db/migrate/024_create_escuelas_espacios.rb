class CreateEscuelasEspacios < ActiveRecord::Migration
  def self.up
    create_table :escuelas_espacios do |t|
      t.integer :numero
      t.integer :espacio_id
      t.integer :entorno_id
    end
  end

  def self.down
    drop_table :escuelas_espacios
  end
end
