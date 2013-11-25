class CreateEntornos < ActiveRecord::Migration
  def self.up
    create_table :entornos do |t|
      t.string :exist_areas_verde, :limit => 3
      t.string :areas_verdes_esc_desc, :limit => 255
      t.string :edo_areas_verdes, :limit => 3
      t.string :edo_areas_verdes_desc, :limit => 255
      t.string :act_areas_verde, :limit => 3
      t.string :cuidado_preserv_reforest_desc, :limit => 255
      t.string :adopta_areas_verdes, :limit => 3
      t.string :adopta_areas_verdes_desc, :limit => 255
      t.string :prom_cuidado_salud, :limit => 3
      t.string :prom_cuidado_salud_desc, :limit => 255
      t.string :prom_act_cartilla, :limit => 3
      t.string :prom_act_cartilla_desc, :limit => 255
      t.string :part_sector_salud, :limit => 3
      t.string :part_sector_salud_desc, :limit => 255
      t.string :prom_act_fisica, :limit => 3
      t.string :prom_act_fisica_desc, :limit => 255
      t.string :tiempo_act_fisica, :limit => 3
      t.string :tiempo_act_fisica_desc, :limit => 255
      t.string :tipo_suelo, :limit => 3
      t.string :tipo_suelo_desc, :limit => 255
      t.string :esc_espacio_fisico, :limit => 3
      t.string :esc_espacio_fisico_desc, :limit => 255
      t.string :alrededores_cuenta_av, :limit => 3
      t.string :alrededores_cuenta_av_desc, :limit => 255
      t.string :aire_libre_contam, :limit => 3
      t.string :aire_libre_contam_desc, :limit => 255
      t.timestamps
      t.integer :diagnostico_id
      
    end
    add_index :entornos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :entornos
  end
end
