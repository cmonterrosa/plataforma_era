class CreateConsumosHigienesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_higienes, :id => false do |t|
      t.integer :consumo_id
      t.integer :higiene_id
    end
  end

  def self.down
    drop_table :consumos_higienes
  end
end
