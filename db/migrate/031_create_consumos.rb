class CreateConsumos < ActiveRecord::Migration
  def self.up
    create_table :consumos do |t|
      t.string :desayunos_esc, :limit => 3
      t.string :desayunos_esc_desc, :limit => 255
      t.string :tipo_establec, :limit => 3
      t.string :apli_lineamientos, :limit => 3
      t.string :apli_lineamientos_desc, :limit => 255
      t.string :capacita_prep_alim, :limit => 3
      t.string :capacita_prep_alim_desc, :limit => 255
      t.string :alim_chatarras, :limit => 3
      t.string :alim_chatarras_desc, :limit => 255
      t.string :alim_norma_ofic, :limit => 3
      t.string :alim_norma_ofic_desc, :limit => 255
      t.string :alim_bajos_sodio_grasa, :limit => 3
      t.string :alim_bajos_sodio_grasa_desc, :limit => 255
      t.string :agua_simple_potable, :limit => 3
      t.string :agua_simple_potable_desc, :limit => 255
      t.string :alim_higienicos, :limit => 3
      t.string :alim_higienicos_desc, :limit => 255
      t.string :utensilios_esterilizados, :limit => 3
      t.string :utensilios_esterilizados_desc, :limit => 255
      t.string :reciptes_sol_org_inorg, :limit => 3
      t.string :reciptes_sol_org_inorg_desc, :limit => 255
      t.string :establec_sin_fauna, :limit => 3
      t.string :establec_sin_fauna_desc, :limit => 255
      t.string :consumo_alim_chatarra, :limit => 3
      t.string :consumo_alim_chatarra_desc, :limit => 255
      t.string :alim_beb_salud, :limit => 3
      t.string :alim_beb_salud_desc, :limit => 255
      t.string :porcentaje_obesidad, :limit => 3
      t.string :porcentaje_obesidad_desc, :limit => 255
      t.string :problemas_salud, :limit => 3
      t.string :problemas_salud_desc, :limit => 255
      t.string :enfermedades_gastro, :limit => 3
      t.string :enfermedades_gastro_desc, :limit => 255
      t.string :material_servir_alim, :limit => 3
      t.string :material_servir_alim_desc, :limit => 255
      t.string :utilizan_popotes, :limit => 3
      t.string :utilizan_popotes_desc, :limit => 3
      t.timestamps
      t.integer :diagnostico_id
      t.integer :establecimiento_id
      t.integer :cubierto_id
      t.integer :plato_id
      t.integer :vaso_id
#      t.integer :problemas_salud_id
    end
    add_index :consumos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :consumos
  end
end
