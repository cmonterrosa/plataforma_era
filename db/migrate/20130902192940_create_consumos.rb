class CreateConsumos < ActiveRecord::Migration
  def self.up
    create_table :consumos do |t|
      t.string :desayunos_escolares, :limit => 3
      t.string :tipo_establecimiento, :limit => 20
      t.string :aplican_norma_ofic_mex, :limit => 3
      t.string :capacita_manejo_prep_alimentos, :limit => 3
      t.string :disminuido_alim_chatarras, :limit => 3
      t.string :alim_norma_ofic_mex, :limit => 3
      t.string :alim_bajos_sodio_grasa, :limit => 3
#      t.string :alim_bajos_sodio_grasa_desc, :limit => 255 # Agregado
      t.string :agua_simple_potable, :limit => 3
      t.string :alim_preparan_higienica, :limit => 3
      t.string :utensilios_esterilizados, :limit => 3
      t.string :recipientes_residuos_solidos, :limit => 3
      t.string :material_servir_alim, :limit => 50
      t.string :utilizan_popotes, :limit => 3
      t.string :libres_fauna_nociva, :limit => 3
      t.string :reperc_alim_chatarra, :limit => 3           # Agregado
      t.string :platicas_alim_bebidas, :limit => 3          #
      t.string :porcentaje_obesidad, :limit => 3            #
      t.string :inasist_problem_salud, :limit =>3           #
      t.string :enfermedades_gastro, :limit => 3            #
      t.string :enfermedades_gastro_desc, :limit => 255          # Fin Agregado
      t.timestamps
      t.integer :diagnostico_id
    end
    add_index :consumos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :consumos
  end
end
