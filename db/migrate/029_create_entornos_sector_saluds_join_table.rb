class CreateEntornosSectorSaludsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :entornos_sector_saluds, :id => false do |t|
      t.integer :entorno_id
      t.integer :sector_salud_id
    end
  end

  def self.down
    drop_table :entornos_sector_saluds
  end
end
