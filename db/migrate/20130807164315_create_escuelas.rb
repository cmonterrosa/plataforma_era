class CreateEscuelas < ActiveRecord::Migration
  def self.up
    create_table :escuelas do |t|
        t.string :clave, :limit => 15
        t.string :nombre, :limit => 20
        t.string :zona_escolar, :limit => 20
        t.string :sector, :limit => 10
        t.integer :nivel_id
    end
    add_index :escuelas, :clave, :unique => true
  end

  def self.down
    drop_table :escuelas
  end
end
