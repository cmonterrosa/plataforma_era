class CreateEntornosActividadsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :entornos_actividads, :id => false do |t|
      t.integer :entorno_id
      t.integer :actividad_id
    end
  end

  def self.down
    drop_table :entornos_actividads
  end
end
