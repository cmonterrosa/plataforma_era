class CreateEntornos < ActiveRecord::Migration
  def self.up
    create_table :entornos do |t|
      t.float :superficie_terreno_escuela
      t.float :superficie_terreno_escuela_av
      t.string :escuela_reforesta, :limit => 2
      t.integer :escuela_reforesta_num
      t.string :arboles_nativos, :limit => 2
      t.integer :arboles_nativos_num
      t.string :arboles_nativos_desc
      t.string :arboles_no_nativos, :limit => 2
      t.integer :arboles_no_nativos_num
      t.string :arboles_no_nativos_desc
      t.integer :diagnostico_id
      t.timestamps
      
    end
    add_index :entornos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :entornos
  end
end
