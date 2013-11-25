class CreateEntornosCuidadoSaludsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :entornos_cuidado_saluds, :id => false do |t|
      t.integer :entorno_id
      t.integer :cuidado_salud_id
    end
  end

  def self.down
    drop_table :entornos_cuidado_saluds
  end
end
