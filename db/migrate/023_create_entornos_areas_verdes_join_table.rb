class CreateEntornosAreasVerdesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :entornos_areas_verdes, :id => false do |t|
      t.integer :entorno_id
      t.integer :areas_verde_id
    end
  end

  def self.down
    drop_table :entornos_areas_verdes
  end
end
