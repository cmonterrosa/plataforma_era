class CreateConsumosEstablecimientosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_establecimientos, :id => false do |t|
      t.integer :consumo_id
      t.integer :establecimiento_id
    end
  end

  def self.down
    drop_table :consumos_establecimientos
  end
end
