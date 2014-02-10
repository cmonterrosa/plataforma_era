class CreateConsumosUtensiliosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :consumos_utensilios, :id => false do |t|
      t.integer :consumo_id
      t.integer :utensilio_id
    end
  end

  def self.down
    drop_table :consumos_utensilios
  end
end
