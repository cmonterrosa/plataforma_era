class CreateEntornosAccionesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :entornos_acciones, :id => false do |t|
      t.integer :entorno_id
      t.integer :accione_id
    end
  end

  def self.down
    drop_table :entornos_acciones
  end
end
