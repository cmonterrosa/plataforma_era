class CreateEntornos < ActiveRecord::Migration
  def self.up
    create_table :entornos do |t|
      t.string :areas_verdes_esc, :limit => 3
      t.string :areas_verdes_esc_desc, :limit => 255
      t.string :cuidado_preserv_reforest, :limit => 3
      t.string :cuidado_preserv_reforest_desc, :limit => 255
      t.string :adopta_areas_verdes, :limit => 3
      t.string :adopta_areas_verdes_desc, :limit => 255
      t.string :promueve_cuidado_salud, :limit => 3
      t.string :promueve_cuidado_salud_desc, :limit => 255
      t.string :promueve_activacion_cartilla, :limit => 3
      t.string :participacion_sector_salud, :limit => 50
      t.string :promueve_activacion_fisica, :limit => 3
      t.string :tiempo_activacion_fisica, :limit => 200
      t.string :tipo_suelo, :limit => 255               # Agregado
      t.string :esc_espacio_fisico, :limit => 255       #
      t.string :alrededores_cuenta_av, :limit => 255    #
      t.string :aire_libre_contaminantes, :limit => 255 # Fin Agredo
      t.timestamps
      t.integer :diagnostico_id
    end
    add_index :entornos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :entornos
  end
end
