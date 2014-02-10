class CreateConsumos < ActiveRecord::Migration
  def self.up
    create_table :consumos do |t|
      t.string :conocen_lineamientos_grales, :limit => 2
      t.string :capacitacion_alim_bebidas, :limit => 2
      t.string :cumplen_req_nutricionales, :limit => 2
      t.integer :minutos_activacion_fisica
      t.integer :momentos_activacion_fisica
      t.integer :frecuencia_afisica_id
      
      t.timestamps
      t.integer :diagnostico_id
      
    end
    add_index :consumos, :diagnostico_id, :name => "diagnostico"
  end

  def self.down
    drop_table :consumos
  end
end
