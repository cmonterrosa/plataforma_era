class CreateConsumosEnfermedadsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_enfermedads, :id => false do |t|
      t.integer :consumo_id
      t.integer :enfermedad_id
    end
  end

  def self.down
    drop_table :consumos_enfermedads
  end
end
