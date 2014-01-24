class CreateEntornos < ActiveRecord::Migration
  def self.up
    create_table :entornos do |t|
      t.float :superficie_terreno_escuela
      t.float :superficie_terreno_escuela_av
      t.integer :arboles_terreno_escuela
      t.timestamps
      t.integer :diagnostico_id
      
    end
    add_index :entornos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :entornos
  end
end
