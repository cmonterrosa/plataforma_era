class CreateHuellas < ActiveRecord::Migration
  def self.up
    create_table :huellas do |t|
      t.string :capacitacion_ahorro_energia
      t.float  :consumo_anterior
      t.float  :consumo_actual
      t.integer :total_focos
      t.integer :focos_ahorradores
      t.integer :focos_incandescentes
      
      t.integer :mantto_inst
      
      t.string :sep_residuos_org_inorg, :limit => 3
      t.string :elabora_compostas, :limit => 3
      
      t.integer :energia_electrica_id
      
      t.integer :diagnostico_id
      t.timestamps
    end

     add_index :huellas, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :huellas
  end
end
