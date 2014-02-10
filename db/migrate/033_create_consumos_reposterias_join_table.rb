class CreateConsumosReposteriasJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_reposterias, :id => false do |t|
      t.integer :consumo_id
      t.integer :reposteria_id
    end
  end

  def self.down
    drop_table :consumos_reposterias
  end
end
