class CreateConsumosBotanasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_botanas, :id => false do |t|
      t.integer :consumo_id
      t.integer :botana_id
    end
  end

  def self.down
    drop_table :consumos_botanas
  end
end
