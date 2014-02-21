class CreateConsumosPreparacionsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_preparacions, :id => false do |t|
      t.integer :consumo_id
      t.integer :preparacion_id
    end
  end

  def self.down
    drop_table :consumos_preparacions
  end
end
