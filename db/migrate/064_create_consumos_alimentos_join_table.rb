class CreateConsumosAlimentosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_alimentos, :id => false do |t|
      t.integer :consumo_id
      t.integer :alimento_id
    end
  end

  def self.down
    drop_table :consumos_alimentos
  end
end
