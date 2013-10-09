class CreateParticipacions < ActiveRecord::Migration
  def self.up
    create_table :participacions do |t|
#      t.string :apoyo_proy_product, :limit => 3
#      t.string :apoyo_proy_product_desc, :limit => 255
      t.string :familia_involucran_actividades, :limit => 3
      t.string :familia_involucran_actividades_desc, :limit => 255
      t.string :esc_participa_proy, :limit => 3
      t.string :esc_participa_proy_desc, :limit => 255
      t.string :esc_capacita_salud_ma, :limit => 3
      t.string :esc_capacita_salud_ma_desc, :limit => 255
      t.string :padres_participan_proy, :limit => 3
      t.string :padres_participan_proy_desc, :limit => 255
      t.string :proy_vincula_comunidad, :limit => 3                 # Agregado
      t.string :proy_vincula_comunidad_desc, :limit => 255          #
      t.string :familia_participa_acciones, :limit => 3                  #
      t.string :familia_participa_acciones_desc, :limit => 255      #
#      t.string :acciones_padres_ma, :limit => 3                     #
      t.string :acciones_padres_ma_desc, :limit => 255              #
#      t.string :padres_aprov_esc_hijos, :limit => 3                 #
      t.string :padres_aprov_esc_hijos_desc, :limit => 255          #
#      t.string :promueven_aprendizajes, :limit => 3                 #
      t.string :promueven_aprendizajes_desc, :limit => 255               # Fin Agregado
      
      t.timestamps
      t.integer :diagnostico_id
    end
    add_index :participacions, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :participacions
  end
end
