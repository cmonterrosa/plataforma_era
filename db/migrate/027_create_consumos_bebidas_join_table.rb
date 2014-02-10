class CreateConsumosBebidasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_bebidas, :id => false do |t|
      t.integer :consumo_id
      t.integer :bebida_id
    end
  end

  def self.down
    drop_table :consumos_bebidas
  end
end
