class CreateHuellas < ActiveRecord::Migration
  def self.up
    create_table :huellas do |t|

      t.string :mant_instalaciones, :limit => 3
     

      #### APARATOS ELECTRONICOS ########

      t.integer :computadoras_num
      t.string :computadoras_hrs_diarias, :limit => 3

      t.integer :impresoras_num
      t.string :impresoras_hrs_diarias, :limit => 3

      t.integer :proyectores_num
      t.string :proyectores_hrs_diarias, :limit => 3

      t.integer :reguladores_num
      t.string :reguladores_hrs_diarias, :limit => 3

      t.integer :ventiladores_num
      t.string :ventiladores_hrs_diarias, :limit => 3

      t.integer :climas_num
      t.string :climas_hrs_diarias, :limit => 3

      t.integer :enfriadores_num
      t.string :enfriadores_hrs_diarias, :limit => 3

      t.integer :cafeteras_num
      t.string :cafeteras_hrs_diarias, :limit => 3

      t.integer :refrigeradores_num
      t.string :refrigeradores_hrs_diarias, :limit => 3

      t.integer :bombas_agua_num
      t.string :bombas_agua_hrs_diarias, :limit => 3

      t.integer :aparatos_sonido_num
      t.string :aparatos_sonido_hrs_diarias, :limit => 3

      t.string :desconectan_equipos_elec, :limit => 3
      t.string :utilizan_lamp_ahorradoras, :limit => 3
      t.string :aprovecha_luz_natural, :limit => 3

      ####### Tipo de agua #######
      t.integer :tipo_agua_id
      t.integer :potabilidad_agua_id

      t.integer :sanitarios_num
      t.string :sanitarios_fugas, :limit => 3

      t.integer :bebederos_num
      t.string :bebederos_fugas, :limit => 3

      t.integer :tomas_agua_num
      t.string :tomas_agua_fugas, :limit => 3

      t.integer :cisternas_num
      t.string :cisternas_fugas, :limit => 3

      t.string :captacion_agua_pluv, :limit => 3

      t.string :reutiliza_agua, :limit => 3
      t.string :reutiliza_agua_desc, :limit => 255

      t.string :recip_residuos_solid, :limit => 3
      t.integer :recip_residuos_solid_numero

      t.string :separa_residuos_org_inorg, :limit => 3

      t.string :elabora_compostas_residuos, :limit => 3

      t.string :cuenta_recipientes_org_inorg, :limit => 3
      t.integer :cuenta_recipientes_org_inorg_num

      t.string :aparatos_pilas, :limit => 3
      t.integer :aparatos_pilas_num

      t.string :meca_elim_residuos_solid, :limit => 255

      t.string :act_reutiliza_residuos, :limit => 3
      t.string :act_reutiliza_residuos_desc, :limit => 255

      #### Vinculo con tabla padre #######
      t.integer :diagnostico_id
      t.timestamps
    end

     add_index :huellas, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :huellas
  end
end
