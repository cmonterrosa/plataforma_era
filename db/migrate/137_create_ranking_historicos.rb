class CreateRankingHistoricos < ActiveRecord::Migration
   def self.up
    create_table :ranking_historicos do |t|
      t.integer :rank
      t.integer :nivel_certificacion
      t.integer :nivel_id
      t.integer :escuela_id
      t.integer :corte_id
      t.string :clave, :limit => 15
      t.string :puntaje_total, :limit => 10
      t.string :municipio, :limit => 60
      t.string :localidad, :limit => 60
    end
    add_index :ranking_historicos, :corte_id, :name => "corte"
  end

  def self.down
    drop_table :ranking_historicos
  end
end
