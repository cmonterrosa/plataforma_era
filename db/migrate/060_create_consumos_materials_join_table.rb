class CreateConsumosMaterialsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_materials, :id => false do |t|
      t.integer :consumo_id
      t.integer :material_id
    end
  end

  def self.down
    drop_table :consumos_materials
  end
end
