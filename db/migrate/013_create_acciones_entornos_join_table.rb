class CreateAccionesEntornosJoinTable < ActiveRecord::Migration
  def self.up
    create_table :acciones_entornos, :id => false do |t|
      t.integer :entorno_id
      t.integer :accione_id
    end
  end

  def self.down
    drop_table :acciones_entornos
  end
end
